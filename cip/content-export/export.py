# Author: Matt Sullivan
# Updated: 2020-08
#
# Prereqs env variables
#   SUMO_ACCESS_ID=xxx
#   SUMO_ACCESS_KEY=yyyyyy
#   SUMO_ENDPOINT=https://api.us2.sumologic.com/api/v1 (or change if not US2)
#
# usage:
#    backupContent.py
#
#  Executes a "full backup" starting at global folder with admin mode
#  exports all user folders using multi-thread, as well as FERs, Partitions, etc.
#  stores results in child folder from script runtime, as set below

import re
from datetime import datetime
from sumo_shared import *

# consts
BATCH_SIZE = 10 # how many users to export in parallel, careful upping can cause 429s
BACKUP_FOLDER = './backupContent_' + datetime.now().strftime('%Y_%m_%d_%H%M%S')

# classes
def saveGlobalObjects (sumo, objtype, filename=None):
    if filename==None: filename=objtype
    jsonfile = BACKUP_FOLDER + '/' + objtype + '.json'
    j = sumo.getObjects(objtype)
    with open(jsonfile, 'w') as data_file:
        json.dump(j, data_file)
    logging.info('Saved ' + objtype + ' to ' + jsonfile)
    return

class saveFolderThread (threading.Thread):
    def __init__(self, f, s): # f=folder json blob, s=sumohandler
        super(saveFolderThread, self).__init__()
        self.threadID = f['id']
        self.name = re.sub(r'[^\w]', '_', f['name'])
        self.results = 'not run'
        self.sumo=s

        if f['itemType'] != 'Folder':
            self.results = f['id'] + 'is not a folder'
            return

    def run(self):
        savepath = BACKUP_FOLDER + '/' + self.threadID + '_' + self.name
        # try to get the entire folder in 1 shot, failing that break it up
        r = self.exportContent(self.threadID, savepath)
        if 200 == r.status_code:
            if len(r.json()['children']) > 0:
                self.results = 'exported successfully as JSON'
            else:
                self.results = 'skipped, user has no content'
        else:
        # try recursively
            if not os.path.exists(savepath):
                os.makedirs(savepath)
            r = self.recurseExport(self.threadID, savepath)
            if 200 == r.status_code:
                self.results = 'exported successfully as folder'
            else:
                self.results = 'failed'
        return
    
    def recurseExport (self, id, savepath):
        time.sleep(0.5)
        j = self.sumo.get_folder(id, True)
        r = None

        # save the child objects
        for c in j['children']:
            newpath = savepath + '/' + re.sub(r'[^\w]', '_', c['name'])
            if c['itemType'] == 'Folder':
                # try first as single JSON, failing that create another subfolder and break up the work
                r = self.exportContent (c['id'], newpath)
                if 200 != r.status_code:
                    if not os.path.exists(newpath):
                        os.makedirs(newpath)
                    r = self.recurseExport(c['id'], newpath)
                    if 200 != r.status_code: return r
            else:
                r = self.exportContent (c['id'], newpath)
                if 200 != r.status_code: return r
        return r

    def exportContent (self, id, savepath):
        time.sleep(0.5)
        r = self.sumo.exportContent(id, True)
        if 200 == r.status_code:
            with open(savepath + '.json', 'w') as data_file:
                json.dump(r.json(), data_file)
        return r

startTime = int(time.time())
# get the top level folder
sumov1=SumoHandler()
sumov2=SumoHandler(apirev=2)

if not os.path.exists(BACKUP_FOLDER):
    os.makedirs(BACKUP_FOLDER)

# Save off Connections, FERs, Partitions, Scheduled Views, Ingest Budgets, Roles
saveGlobalObjects(sumov1, 'connections')
saveGlobalObjects(sumov1, 'extractionRules')
saveGlobalObjects(sumov1, 'partitions')
saveGlobalObjects(sumov1, 'scheduledViews')
saveGlobalObjects(sumov1, 'users')
saveGlobalObjects(sumov1, 'roles')
saveGlobalObjects(sumov1, 'ingestBudgets')
# saveGlobalObjects(sumov2, 'metrics/alerts/monitors', 'metrics_monitors') # 404s
# TBD v2 lookups

# Admin Recommended
arf = sumov2.get_admin_recommended(True) #admin mode
t = saveFolderThread(arf.json(), sumov2)
t.start()
t.join()
log = t.threadID + ' ' + t.name + ' results: ' + str(t.results)
logging.info (log)

# User Content
gf = sumov2.get_globalfolder(True) #admin mode
folders = gf.json()['data']
logging.info(str(len(folders)) + ' user folders found.')

# spawn threads to pull user folders in parallel
i = 0
batchnum = 1
userFails = ''
while (i < len(folders)):
    j=0
    logging.info('starting batch #' + str(batchnum))
    batchnum +=1
    threads = []
    while (j < BATCH_SIZE and i < len(folders)):
        # if folders[i]['name'][0:1] == 'W':  # use for spot testing, only does users with J
        newThread=saveFolderThread(folders[i], sumov2)
        time.sleep(1.0)
        newThread.start()
        threads.append(newThread)
        j += 1
        i += 1
    for t in threads:
        t.join()
        log = t.threadID + ' ' + t.name + ' results: ' + str(t.results)
        logging.info (log)
        if 'failed' == t.results:
            userFails += log + '\n'

# log the duration, etc.
endTime = int(time.time())
if userFails != '': logging.error('Failed backups: \n' + userFails)
logging.info ('Script Duration in seconds: ' + str(endTime-startTime))