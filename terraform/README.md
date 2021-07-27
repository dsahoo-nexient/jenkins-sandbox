## Jenkins Master setup using Terraform

### Pre-requisites

In the current implementation, the following assumption has been made
- A domain name exists `dsahoo.com`. An A-record will be created by tf as `jenkinsmaster.dsahoo.com`
- A certificate exists for jenkinsmaster.dsahoo.com in the respective region
- In the ECS task definition, a role is present for `taskExecutionRole` whose ARN will be provided in variables.tf


### Run the module
```buildoutcfg
cd terraform
terraform init
terraform apply -var-file ../aws_credentials.tfvars
```