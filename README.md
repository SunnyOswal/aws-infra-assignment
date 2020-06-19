## APPLICATION ##

## NodeJs Install ##
* Install <a href="https://nodejs.org/en/download/" target="_blank">Node.js</a>
* Open cmd.exe and navigate to project's folder.
* Install project dependencies with following command

`npm install`

## Run ##
Run project with following command

`npm start`

## Local Endpoints ##
* GET endpoints are: http://localhost:3000/ad
* POST endpoint is: http://localhost:3000/ad-event

## APPLICATION CONTAINERIZATION ##
Assumptions:
For windows OS, "Docker Desktop" is preinstalled with linux containers selected as default option.

* Create Dockerfile in root directory and update according to application.
* Build docker image by running following command in cmd.exe in root directory  
`docker build . -t ad-service`
* Run docker container by running following command in cmd.exe in root directory  
`docker run -p 3000:3000 ad-service`

## INFRASTRUCTURE ##

## AWS CLI Install ##
* Install the <a href="https://nodejs.org/en/download/" target="_blank">AWS CLI</a> and run follwing command  
`aws configure`  
* The AWS CLI will then verify and save your AWS Access Key ID and Secret Access Key.

## Terraform Install ##
* Find the appropriate <a href="https://nodejs.org/en/download/" target="_blank">terraform</a> package for your system and download it. Terraform is packaged as a zip archive.
* After downloading Terraform, unzip the package. Terraform runs as a single binary named terraform. Any other files in the package can be safely removed and Terraform will still function.
* The final step is to make sure that the terraform binary is available on the PATH. 
* Open cmd.exe and run following command  
`terraform --version`
* If setup was installed correctly, you will see the version of terraform like below  
`Terraform v0.12.12`

## Creating AWS ECR from terraform ##
* Open cmd.exe and Switch to "terraform-ecr" directory.
* Initialize by running following command  
`terraform init`
* Validate terraform scripts for syntax and other errors by running following command  
`terraform validate`
* Expected output  
<pre>Success! The configuration is valid.</pre>
* Check what resources will be created by running following command  
`terraform plan`
* Expected output   
<pre>Plan: 1 to add, 0 to change, 0 to destroy.</pre>
* If all looks fine, to create "aws ecr" , run following command  
`terraform apply -auto-approve`
* Expected output   
<pre>
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

repository_url = XXXXXXXXXXX.dkr.ecr.ap-southeast-1.amazonaws.com/ad-service-ecr
</pre>
* Copy the repository url. This will be used for deploying ECS.  

## Pushing application image to AWS ECR ##
* Install <a href="https://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi" target="_blank">AWS Tools for Windows PowerShell module</a> .
* Open powershell.exe and Switch to application root directory.
* Replace XXXXXXXXXXX with AWS account id from ecr repository url copied earlier & Run following commands  
`$(aws ecr get-login --no-include-email --region ap-southeast-1)`  
`docker build -t ad-service .`  
`docker tag ad-service:latest XXXXXXXXXXX.dkr.ecr.ap-southeast-1.amazonaws.com/ad-service:latest`  
`docker push XXXXXXXXXXX.dkr.ecr.ap-southeast-1.amazonaws.com/ad-service:latest`


## Creating AWS ECS & related components ##
* In "terraform" folder in application directory , edit "task-definitions-service.json" file and Replace XXXXXXXXXXX with AWS account id from ecr repository url copied earlier and save file  
<pre>"image": "XXXXXXXXXXX.dkr.ecr.ap-southeast-1.amazonaws.com/ad-service:latest"</pre>
* Open cmd.exe and , change working directory to "terraform" directory.  
* Initialize by running following command  
`terraform init`
* Validate terraform scripts for syntax and other errors by running following command  
`terraform validate`
* Expected output  
<pre>Success! The configuration is valid.</pre>
* Check what resources will be created by running following command  
`terraform plan`
* Expected output  
<pre>Plan: 21 to add, 0 to change, 0 to destroy.</pre>
* If all looks fine, run following command  
`terraform apply -auto-approve`
* Expected output  
<pre>Apply complete! Resources: 21 added, 0 changed, 0 destroyed.</pre>

## How to get REST Endpoint ##
* In AWS Console, browse to below path to get aws ALB DNS:  
`ec2 > Load Balancers > ad-service-lb > DNS Name`  
* Expected format  
<pre>ad-service-lb-ZZZZZZZZ.ap-southeast-1.elb.amazonaws.com</pre>

## How to call REST Endpoints ##
* Replace below command with load balancer endpoint and running following command  
`curl ad-service-lb-ZZZZZZZZ.ap-southeast-1.elb.amazonaws.com:3000/ad`
* Expected output  
<pre>[{"id":1,"bid":100,"currency":"USD"},{"id":1,"bid":200,"currency":"HKD"}]</pre>

* Replace below command with load balancer endpoint and running following command  
`curl -d "{\"id\":\"3\",\"bid\":\"300\",\"currency\":\"HKD\"}" -H "Content-Type:application/json" -X POST http://ad-service-lb-ZZZZZZZZ.ap-southeast-1.elb.amazonaws.com:3000/ad-event`
* Expected output  
<pre>Added Ad with id=3</pre>

* Replace below command with load balancer endpoint and running following command  
`curl ad-service-lb-ZZZZZZZZ.ap-southeast-1.elb.amazonaws.com:3000/ad`
* Expected output(Run this couple of times . To get below response from the same instance which accepted previous POST request)  
<pre>[{"id":1,"bid":100,"currency":"USD"},{"id":1,"bid":200,"currency":"HKD"},{"id":"3","bid":"300","currency":"HKD"}] </pre>


## Looking at cloudwatch logs ##
* In AWS Console, browse to below path to see request logged in:  
`CloudWatch > CloudWatch Logs > Log groups > /ecs/ad-service > ad-service-ecs/ad-service/ebce1434-4d7d-45c1-b31d-2de3012b9fc5`

## Monitoring of service degradation and alerting ##
* Cloud watch log and alarms are configured for tracing and monitoring.
* Auto scaling is enabled using auto scaling policies and cloud watch alarms.
* Incase of service degradatiom, auto scaling up event happens and scales up instance to cater to load.
* Incase of low CPU, auto scaling down event happens and scales downs instance to desired count.

## Looking at cloudwatch alarms ##
* On making repeated 8-9 requests to service endpoints, it will trigger an alarm.
* In AWS Console, browse to below path to see request logged in:  
`CloudWatch > Alarms > ad-service-cpu-utilization-low`

## Autoscaling based on CPU percentage (load) ##
* On making repeated 8-9 requests to service endpoints, it will trigger an alarm, which triggers auto scaling policy and will scale up ecs instances.
* In AWS Console, browse to below path to see increase tasks/instances at the time of autoscaling up event:  
`Clusters > ad-service-cluster`


## CI pipeline is configured using CodeBuild ##
* For now only buildspec.yml file is created to build image and push changes to AWS ECR

## CI-CD Flow Design ##
* CI: Commit to sourcecontrol (github) > CodeBuild builds and pushes image to ECR
* CD: Configure CodeDeploy for blue-green deployments and fetch latest image from ECR and update ECS instances.

## Cleaning up resources created by terraform ##
* In cmd.exe, change working directory to "terraform-ecr" directory and run following command  
`terraform destroy -auto-approve`
* Expected output  
<pre>Destroy complete! Resources: 1 destroyed.</pre>
* In cmd.exe, change working directory to "terraform" directory and run following command  
`terraform destroy -auto-approve`
* Expected output  
<pre>Destroy complete! Resources: 21 destroyed.</pre>