# Jenkins-sandbox
All the Jenkins Plugins are defined in `plugins/plugins.txt` All the plugin configurations are defined in yaml files inside `casc/*.yaml`

# High level plan

- Jenkins Master
    - Run on ECS either on EC2 backend or Fargate depends on requirement
    - Starts with the following plugins configured
        - Jenkins configuration as code
        - Jenkins Job DSL plugin to generate jobs on-the-fly from the seed-job
        - Configured with a seed job
        - Jenkins Shared library enabled to store all the reusable code
        - AWS ECS plugin to enable slaves on fargate
- Slaves
    - ephemeral nodes running on ECS Fargate
    - on demand start/stop when a job is scheduled to run
    
- Jenkins Shared Library repo
    - Shared library configured in Jenkins. Can be invoked from Jenkinsfile
- Job DSL repo  
    - Repo containing all the jobs to be created on Jenkins
- Terraform
    - Use terraform to stand up the infrastructure of Jenkins master running on ECS with ALB, Route53 configured.
## Create Docker image locally
```buildoutcfg
docker build -t jenkins-sandbox:1.0.0 .
```

## Run Docker image locally
```buildoutcfg
docker run -d --name=jenkins-local --rm \
    -p 8080:8080 -p 50000:50000 
    -e AWS_ACCESS_KEY=<> 
    -e AWS_SECRET_KEY=<> 
    -e AWS_REGION=<> 
    -e AWS_ACCOUNT_NUMBER=<> 
    jenkins-sandbox:1.0.0 
```
## Push to ECR Repository
```buildoutcfg
aws ecr create-repository --repository-name jenkins-sandbox --image-scanning-configuration scanOnPush=false
# 753492139907.dkr.ecr.us-east-2.amazonaws.com/jenkins-sandbox
# Login to ECR
aws ecr get-login-password | sudo docker login --username AWS --password-stdin 753492139907.dkr.ecr.us-east-2.amazonaws.com
# Tag the local docker image
sudo docker tag jenkins-sandbox:1.0.0 753492139907.dkr.ecr.us-east-2.amazonaws.com/jenkins-sandbox:1.0.0
# Push the docker image to ECR
sudo docker push  753492139907.dkr.ecr.us-east-2.amazonaws.com/jenkins-sandbox:1.0.0
```

## Jenkins Master setup on ECS cluster
1. Create a VPC with the following
    - 3 Subnets
    - Internet Gateway
    - Route Table
    - Security group with incoming traffic to 80 and 50000
    
2. Set up Application Load Balancer
    - Create an ALB
    - Create Security Group for ALB with incoming traffic from 443
    - Create a HTTPS Listener
    - Create a target Group for HTTPS Listener
    
3. Create Certificate for `jenkins.dsahoo.com` in certificate manager
   
4. Create a CNAME record in Route53 to point to the ALB created in Step 2
5. Create a ECS Cluster
6. Create a ECS Task Definition for Jenkins Master
    - Docker image from ECR `753492139907.dkr.ecr.us-east-2.amazonaws.com/jenkins-sandbox:1.0.0`
    - Container Ports 8080 and 50000
    - Environment Variables `AWS_ACCESS_KEY` and `AWS_SECRET_KEY`
    
7. Create an ECS Service
    - type `FARGATE`
    - point to task definition created in step 6
    - Attach to ALB and TG created in step 2
    - Enable Discovery service
        - Create a private dns with 
            - Namespace: jenkins
            - Records: A and SRV with port 50000
## Important links 
- Jenkins Plugins https://plugins.jenkins.io/
- Jenkins Config-as-code
- Jenkins Job DSL
- Jenkins Shared library
- Jenkins pipeline steps

