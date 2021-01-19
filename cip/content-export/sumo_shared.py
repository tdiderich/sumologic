import sys
import time 
import os
import json
import threading
import requests
import logging
try:
    import coloredlogs
    coloredlogs.install(level='INFO', fmt='%(asctime)s %(levelname)s %(message)s')
except:
    logging.basicConfig(format='%(asctime)s %(levelname)s %(message)s', datefmt='%Y-%m-%d %H:%M:%S', level=logging.INFO)
from requests.auth import HTTPBasicAuth
try:
    import cookielib
except ImportError:
    import http.cookiejar as cookielib

#Sumo API endpoint URL prefixes
SUMO_ENDPOINTS=dict( \
    US1='https://api.sumologic.com/api/v1', \
    US2='https://api.us2.sumologic.com/api/v1', \
    AU='https://api.au.sumologic.com/api/v1', \
    EU='https://api.eu.sumologic.com/api/v1', \
    DE='https://api.de.sumologic.com/api/v1', \
    CA='https://api.ca.sumologic.com/api/v1', \
    IN='https://api.in.sumologic.com/api/v1', \
    JP='https://api.jp.sumologic.com/api/v1', \
    FED='https://api.fed.sumologic.com/api/v1')

#env variable names
ENV_SUMO_ACCESS_ID = os.environ['CIP_ACCESS_ID']
ENV_SUMO_ACCESS_KEY = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']
ENV_SUMO_API_ENDPOINT = f'https://api.{cip_deployment}.sumologic.com/api/v1'

# stash for other scripts 
ENV_SUMO_API_HOST = 'SUMO_API_HOST' # prefer start using this form, e.g. api.us2.sumologic.com since some APIs are V2 vs. V1
ENV_SUMO_API_PROXY = 'SUMO_API_PROXY'
ENV_SUMO_HTTP_URL = 'SUMO_HTTP_URL'

#Sumo query API consts
SUMO_Q_STATUS_STATE='state'
SUMO_Q_STATUS_RECORDCOUNT='recordCount'
SUMO_Q_STATUS_MESSAGECOUNT='messageCount'
SUMO_Q_STATE_DONE = 'DONE GATHERING RESULTS'
SUMO_Q_STATE_CANCELED = 'CANCELLED'
SUMO_Q_RESULT_FIELDS = 'fields'
SUMO_Q_RESULT_MAP = 'map'
SUMO_Q_RESULT_RECORDS = 'records'
SUMO_Q_RESULT_MESSAGES = 'messages'
SUMO_Q_RESULT_FIELD_NAME = 'name'
SUMO_Q_RESULT_FIELD_TYPE = 'fieldType'

class SumoHandler(object):
# todo - combine this class with the next one. this is just hack to remove SDK dependency
    def __init__(self, callerthread=None, accessId=None, accessKey=None, endpoint=None, cookieFile='cookies.txt', proxy=None, apirev=1):
        self.session = requests.Session()
        self.session.auth = (accessId, accessKey)
        if accessId==None:
            self.session.auth = (ENV_SUMO_ACCESS_ID, ENV_SUMO_ACCESS_KEY)
        self.session.headers = {'content-type': 'application/json', 'accept': 'application/json'}
        cj = cookielib.FileCookieJar(cookieFile)
        self.session.cookies = cj
        self.proxies = {}
        if not proxy==None:
            self.proxies = {'https': proxy}
        elif ENV_SUMO_API_PROXY in os.environ:
            self.proxies = {'https': os.environ[ENV_SUMO_API_PROXY]}

        self.endpoint = SUMO_ENDPOINTS['US2']
        if not endpoint==None: self.endpoint = endpoint
        elif ENV_SUMO_API_ENDPOINT in os.environ: self.endpoint = os.environ[ENV_SUMO_API_ENDPOINT]

        if apirev > 1: self.endpoint = self.endpoint.replace('/api/v1', '/api/v' + str(apirev)) #hack, we didn't ramp all APIs to V2?

        self.callerthread = callerthread

    def get(self, method, params=None, headers=None):
        r = self.session.get(self.endpoint + method, params=params, headers=headers, proxies=self.proxies)
        retries = 0
        MAXRETRYATTEMPTS = 10
        while 400 <= r.status_code < 600 and retries <= MAXRETRYATTEMPTS :
            retries+=1
            if retries > MAXRETRYATTEMPTS:
                logging.error('get failed, no retries remain.')
                if not self.callerthread == None: self.callerthread.hadUnrecoverableError = True
                break
            logging.warning('GET ' + self.endpoint + method + '?' + str(params) + ' failed with ' + str(r.status_code) + ', retrying')
            logging.debug('get detailed error - status = ' + str(r.status_code) + ' body = ' + r.text)
            time.sleep(1)
            r = self.session.get(self.endpoint + method, params=params, headers=headers, proxies=self.proxies)
            r.reason = r.text
        # r.raise_for_status()
        return r

    def post(self, method, params, headers=None):
        r = self.session.post(self.endpoint + method, data=json.dumps(params), headers=headers, proxies=self.proxies)
        retries = 0
        MAXRETRYATTEMPTS = 10
        while 400 <= r.status_code < 600 and retries <= MAXRETRYATTEMPTS :
            retries+=1
            if retries > MAXRETRYATTEMPTS:
                logging.error('post failed, no retries remain.')
                if not self.callerthread == None: self.callerthread.hadUnrecoverableError = True # todo, combine these classes, this is hacky
                break
            logging.warning('POST ' + self.endpoint + method + '?' + str(params) + ' failed with ' + str(r.status_code) + ', retrying')
            logging.debug('post detailed error - status = ' + str(r.status_code) + ' body = ' + r.text)
            time.sleep(1)
            r = self.session.post(self.endpoint + method, data=json.dumps(params), headers=headers, proxies=self.proxies)
            r.reason = r.text
        # r.raise_for_status()
        return r

    def delete(self, method, params=None):
        r = self.session.delete(self.endpoint + method, params=params, proxies=self.proxies)
        # r.raise_for_status()
        return r

    def put(self, method, params, headers=None):
        r = self.session.put(self.endpoint + method, data=json.dumps(params), headers=headers, proxies=self.proxies)
        # r.raise_for_status()
        return r

    def search_job(self, query, fromTime=None, toTime=None, timeZone='UTC'):
        params = {'query': query, 'from': fromTime, 'to': toTime, 'timeZone': timeZone}
        r = self.post('/search/jobs', params)
        return json.loads(r.text)

    def search(self, query, fromTime=None, toTime=None, timeZone='UTC'):
        params = {'q': query, 'from': fromTime, 'to': toTime, 'tz': timeZone}
        r = self.get('/logs/search', params)
        return json.loads(r.text)

    def search_job_status(self, search_job):
        r = self.get('/search/jobs/' + str(search_job['id']))
        return json.loads(r.text)

    def search_job_records(self, search_job, limit=None, offset=0):
        params = {'limit': limit, 'offset': offset}
        r = self.get('/search/jobs/' + str(search_job['id']) + '/records', params)
        return json.loads(r.text)

    def search_job_messages(self, search_job, limit=None, offset=0):
        params = {'limit': limit, 'offset': offset}
        r = self.get('/search/jobs/' + str(search_job['id']) + '/messages', params)
        return json.loads(r.text)

    def delete_search_job(self, search_job):
        return self.delete('/search/jobs/' + str(search_job['id']))

    def collectors(self, limit=None, offset=None):
        params = {'limit': limit, 'offset': offset}
        r = self.get('/collectors', params)
        return json.loads(r.text)['collectors']

    def collector(self, collector_id):
        r = self.get('/collectors/' + str(collector_id))
        return json.loads(r.text), r.headers['etag']

    def collector_byName(self, collector_name):
        r = self.get('/collectors/name/' + collector_name)
        if r.status_code == 200:
            return json.loads(r.text), r.headers['etag']
        else:
            return {}, ''

    def create_collector(self, data):
        r = self.post('/collectors/' , data)
        return r.text

    def update_collector(self, collector, etag):
        headers = {'If-Match': etag}
        return self.put('/collectors/' + str(collector['collector']['id']), collector, headers)

    def delete_collector(self, collector):
        return self.delete('/collectors/' + str(collector['id']))

    def sources(self, collector_id, limit=None, offset=None):
        params = {'limit': limit, 'offset': offset}
        r = self.get('/collectors/' + str(collector_id) + '/sources', params)
        return json.loads(r.text)['sources']

    def source(self, collector_id, source_id):
        r = self.get('/collectors/' + str(collector_id) + '/sources/' + str(source_id))
        return json.loads(r.text), r.headers['etag']

    def create_source(self, collector_id, source):
        return self.post('/collectors/' + str(collector_id) + '/sources', source)

    def update_source(self, collector_id, source, etag):
        headers = {'If-Match': etag}
        return self.put('/collectors/' + str(collector_id) + '/sources/' + str(source['source']['id']), source, headers)

    def delete_source(self, collector_id, source):
        return self.delete('/collectors/' + str(collector_id) + '/sources/' + str(source['source']['id']))

    def create_content(self, path, data):
        r = self.post('/content/' + path, data)
        return r.text

    def get_content(self, path, headers=None):
        r = self.get('/content/' + path)
        return json.loads(r.text)

    def get_folder(self, id, isAdminMode=False):
        headers = {'accept': 'application/json', 'isAdminMode': str(isAdminMode).lower()}
        path = '/content/folders/' + id
        r = self.get(path, None, headers)
        return json.loads(r.text)
    
    def get_admin_recommended(self, isAdminMode=False):
        headers = {'accept': 'application/json', 'isAdminMode': str(isAdminMode).lower()}
        path = '/content/folders/adminRecommended'
        r = self.get(path, None, headers)
        path += '/' + r.json()['id'] + '/status'
        self.awaitSuccess(path, None, headers)
        path = path.replace('/status', '/result')
        r = self.get(path, None, headers)
        logging.debug(r.text)
        return r

    def get_globalfolder(self, isAdminMode=False):
        headers = {'accept': 'application/json', 'isAdminMode': str(isAdminMode).lower()}
        path = '/content/folders/global'
        r = self.get(path, None, headers)
        path += '/' + r.json()['id'] + '/status'
        self.awaitSuccess(path, None, headers)
        path = path.replace('/status', '/result')
        r = self.get(path, None, headers)
        logging.debug(r.text)
        return r

    def get_personalfolder(self):
        headers = {'accept': 'application/json'}
        path = '/content/folders/personal'
        r = self.get(path, None, headers)
        return r

    def exportContent(self, id, isAdminMode=False):
        headers = {'accept': 'application/json', 'isAdminMode': str(isAdminMode).lower()}
        path = '/content/' + id + '/export'
        r = self.post(path , None, headers)
        path += '/' + r.json()['id'] + '/status'
        r = self.awaitSuccess(path, None, headers)
        if r.json()['status'] == 'Failed': return r

        path = path.replace('/status', '/result')
        r = self.get(path, '', headers)
        logging.debug(r.text)
        return r

    def importContent(self, id, data, isAdminMode=False, overwrite=False):
        headers = {'accept': 'application/json', 'isAdminMode': str(isAdminMode).lower()}
        path = '/content/folders/' + id + '/import?overwrite=' + str(overwrite).lower()
        r = self.post(path, data, headers)
        path = '/content/folders/' + id + '/import/' + r.json()['id'] + '/status'
        self.awaitSuccess(path, None, headers, 1)
        return

    def createFolder(self, data, isAdminMode=False):
        headers = {'accept': 'application/json', 'isAdminMode': str(isAdminMode).lower()}
        r = self.post('/content/folders', data, headers)
        logging.debug(r.text)
        return json.loads(r.text)

    def delete_content(self, path):
        r = self.delete('/content/' + path)
        return json.loads(r.text)

    def dashboards(self, monitors=False):
        params = {'monitors': monitors}
        r = self.get('/dashboards', params)
        return json.loads(r.text)['dashboards']

    def dashboard(self, dashboard_id):
        r = self.get('/dashboards/' + str(dashboard_id))
        return json.loads(r.text)['dashboard']

    def dashboard_data(self, dashboard_id):
        r = self.get('/dashboards/' + str(dashboard_id) + '/data')
        return json.loads(r.text)['dashboardMonitorDatas']

    def users(self):
        return self.getObjects('users')

    def user(self, userid):
        r = self.get('/users/' + userid)
        return json.loads(r.text)

    def delete_user(self, userid, newownerid):
        params = {'transferTo':newownerid}
        return self.delete('/users/' + userid, params)

    def roles(self, params=None, headers=None):
        r = self.get('/roles', params, headers)
        return json.loads(r.text)

    def search_metrics(self, query, fromTime=None, toTime=None, requestedDataPoints=600, maxDataPoints=800):
        '''Perform a single Sumo metrics query'''
        def millisectimestamp(ts):
            '''Convert UNIX timestamp to milliseconds'''
            if ts > 10**12:
                ts = ts/(10**(len(str(ts))-13))
            else:
                ts = ts*10**(12-len(str(ts)))
            return int(ts)

        params = {'query': [{'query':query, 'rowId':'A'}],
                  'startTime': millisectimestamp(fromTime),
                  'endTime': millisectimestamp(toTime),
                  'requestedDataPoints': requestedDataPoints,
                  'maxDataPoints': maxDataPoints}
        r = self.post('/metrics/results', params)
        return json.loads(r.text)

    def awaitSuccess(self, path, params=None, headers=None, interval=5):
        MAXWAIT = 600
        wtime = 0
        status = ''
        while (wtime < MAXWAIT and status!='Success' and status!='Failed'):
            wtime += interval
            time.sleep(interval)
            r = self.get(path, params, headers)
            status = r.json()['status']
            logging.debug(r.text)
        if wtime > MAXWAIT :
            logging.error('awaitSuccess exceeded max wait time')
        return r

    def getObjects(self, objType):
        objJsonArray = json.loads('[]') # start with empty json array
        done = False
        params = {'limit':'1000'}
        # loop until there is no 'next' element, extend the data array
        while not done:
            r = self.get('/' + objType, params)
            resultJson = r.json()
            objJsonArray.extend(resultJson['data'])
            if resultJson['next']:
                params.update({'token':resultJson['next']})
                time.sleep(1)
            else:
                done=True                
        return objJsonArray

# we run sumo query in its own thread to benefit from parallel processing
class sumoQueryThread (threading.Thread):
    def __init__(self, i, n, q, s, e, h=False, m=False, u=None, ai=None, ak=None):
        # i=thread id, n=thread name, q=query, s=startTime, e=endTime, h=hidesheet, m=getMessage, u=url, ai=accesskeyid, ak=accesskey
        super(sumoQueryThread, self).__init__()
        self.threadID = i
        self.name = n
        self.queryText = q
        self.startTime = s
        self.endTime = e
        self.hidesheet = h
        self.getMessages = m
        self.url = u
        self.accessKeyId = ai
        self.accessKey = ak
        self.errorMessage = '' #holds errors
        self.hadUnrecoverableError = False # tells UI thread to abort the mission, call sys.exit()
        self.results = dict() #holds results
        self.resultCount = 0 #holds num records returned
        return

    def run(self):
        logging.info(self.name + ' starting, from: ' + str(self.startTime) + ' to:' + str(self.endTime))
        DELAY = 5 #seconds to poll Sumo
        MAXWAIT = 3600 #seconds overall to wait
        LIMIT = 10000 #max records in result set

        # make sure we have access keys
        if None == self.accessKeyId:
            if ENV_SUMO_ACCESS_ID not in os.environ:
                logging.error('Error: Must have env var: ' + ENV_SUMO_ACCESS_ID)
                self.hadUnrecoverableError = True
                return
            else:
                self.accessKeyId = os.environ[ENV_SUMO_ACCESS_ID]

        if None == self.accessKey:
            if ENV_SUMO_ACCESS_KEY not in os.environ:
                logging.error('Error: Must have env var: ' + ENV_SUMO_ACCESS_KEY)
                self.hadUnrecoverableError = True
                return
            else:
                self.accessKey = os.environ[ENV_SUMO_ACCESS_KEY]

        # we have API keys, real work starts here
        logging.debug('using access key: ' + self.accessKeyId)
        sumo = SumoHandler(self, self.accessKeyId, self.accessKey, self.url, 'Cookies_' + str(self.threadID) + '.txt')
        timeZone = 'EST'
        logging.debug(self.name + ' executing query: ')
        logging.debug(self.queryText)

        sj = sumo.search_job(self.queryText, self.startTime, self.endTime, timeZone)
        status = sumo.search_job_status(sj)
        wait = 0
        while status[SUMO_Q_STATUS_STATE] != SUMO_Q_STATE_DONE:
            if status[SUMO_Q_STATUS_STATE] == SUMO_Q_STATE_CANCELED:
                self.errorMessage = 'Error: Sumo Canceled'
                break
            if (wait >= MAXWAIT):
                self.errorMessage = 'Error: Exceeded max wait time for thread'
                break
            logging.debug(self.name + ' sleeping ' + str(DELAY) + ' (total + ' + str(wait) + ' of ' + str(MAXWAIT) + ' max)')
            time.sleep(DELAY)
            wait += DELAY
            status = sumo.search_job_status(sj)
        if status[SUMO_Q_STATUS_STATE] == SUMO_Q_STATE_DONE:
            logging.debug(status)
            self.results = []
            if self.getMessages == True:
                self.resultCount = status[SUMO_Q_STATUS_MESSAGECOUNT]
            else:
                self.resultCount = status[SUMO_Q_STATUS_RECORDCOUNT]
            remaining = self.resultCount
            if remaining == 0: remaining = 1 # hack to force us into the next loop and get field names
            oset = 0
            while remaining > 0:
                if remaining >= LIMIT:
                    lmt = LIMIT
                    logging.warning('Exceeded limit, calling with offset, remaining = ' + str(remaining))
                else:
                    lmt = remaining
                if self.getMessages == True:
                    jrs = sumo.search_job_messages(sj, limit=lmt, offset=oset)
                else:
                    jrs = sumo.search_job_records(sj, limit=lmt, offset=oset)
                self.results.append(jrs)
                oset+=lmt
                remaining-=lmt
            logging.info(self.name + ' complete, found ' + str(self.resultCount) + ' results')
        return

    def getDataType(self, fname):
        # todo lose this innefficent algo
        fields = self.results[0][SUMO_Q_RESULT_FIELDS]
        for f in fields :
            if fname == f[SUMO_Q_RESULT_FIELD_NAME] : return f[SUMO_Q_RESULT_FIELD_TYPE]
        return 'string'

def postResultsToSumo (sc, d): #pass the sourcecategory and data
    sumourl = os.environ[ENV_SUMO_HTTP_URL]
    postHeaders = {'X-Sumo-Category': sc}
    hr = requests.post(url=sumourl, headers=postHeaders, data=d)
    logging.info ('postToSumo HTTP Status: ' + str(hr.status_code))
    return