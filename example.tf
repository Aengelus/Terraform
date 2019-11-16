# 1. The first command to run for a new configuration -- or after checking out an existing configuration from version control -- is terraform init, which initializes various local settings and data that will be used by subsequent commands.
# Update: The terraform fmt command enables standardization which automatically updates configurations in the current directory for easy readability and consistency.
# Validate: If you are copying configuration snippets or just want to make sure your configuration is syntactically valid and internally consistent, the built in terraform validate command will check and report errors within modules, attribute names, and value types.
# 2. Apply Changes: In the same directory as the example.tf file you created, run terraform apply
# Terraform also wrote some data into the terraform.tfstate file. This state file is extremely important; it keeps track of the IDs of created resources so that Terraform knows what it is managing. This file must be saved and distributed to anyone who might run Terraform.
# Show: You can inspect the current state using terraform show
# State: Terraform has a built in command called terraform state which is used for advanced state management. In cases where a user would need to modify the state file by finding resources in the terraform.tfstate file with terraform state list. This will give us a list of resources as addresses and resource IDs that we can then modify.
# Destroy: Resources can be destroyed using the terraform destroy command

## The provider block is used to configure the named provider, in our case "aws". A provider is responsible for creating and managing resources.
## A provider is a plugin that Terraform uses to translate the API interactions with the service.
## A provider is responsible for understanding API interactions and exposing resources.
## Because Terraform can interact with any API, almost any infrastructure type can be represented as a resource in Terraform.
# AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
# The profile attribute here refers to the AWS Config File in ~/.aws/credentials on MacOS and Linux or %UserProfile%\.aws\credentials on a Windows system.
provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

## The resource block defines a resource that exists within the infrastructure.
## A resource might be a physical component such as an EC2 instance, or it can be a logical resource such as a Heroku application.
# Create a new AWS Instance
resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

# Create a new Datadog monitor
resource "datadog_monitor" "example" {
  name               = "Instance Example"
  type               = "metric alert"
  message            = "Monitor triggered. Notify: @hipchat-channel"
  escalation_message = "Escalation message @pagerduty"

  query = "avg(last_1h):avg:aws.ec2.cpu{host:${aws_instance.example.id}} by {host} > 4"

  thresholds = {
    ok                = 0
    warning           = 2
    warning_recovery  = 1
    critical          = 4
    critical_recovery = 3
  }

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  silenced = {
    "*" = 0
  }
}