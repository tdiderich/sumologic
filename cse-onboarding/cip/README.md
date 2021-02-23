# TL;DR
- This Terraform file will setup an environment for a CSE customer 

# What does it do?
1. Creates a View CSE Role for customers to assign to users 
2. Creates the _siemXXX Fields
3. Creates a cCllector for Records, Signals, and Insights (with separate HTTP Sources)
4. Creates a Collector for CNC connections
5. Creates 3 Partitions for Records, Signals, and Insights
6. Creates an Insight Metrics folder with stock Insights content
7. Creates a SNARF folder with stock SNARF content

# How do I deploy?

1. Create Access Key: https://help.sumologic.com/Manage/Security/Access-Keys
2. Clone this repo 
```
git clone https://github.com/tdiderich/sumologic.git
```
3. cd to the proper directory 
```
cd /sumologic/cse-onboarding/cip
```
4. Install Terraform (Mac commands below): https://learn.hashicorp.com/tutorials/terraform/install-cli
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
5. Initiate Terraform
```
terraform init
```
6. Apply the file to the environment
```
terraform apply
```
7. Supply access keys / confirm deployment of resources 