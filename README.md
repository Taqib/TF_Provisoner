Understanding Terraform Provisioners

Provisioners in Terraform are used to execute scripts or commands on a local or remote machine after a resource has been created or before it is destroyed. They provide a way to perform additional configuration steps or to initiate tasks that aren’t natively supported by Terraform. However, provisioners should be used cautiously and as a last resort when necessary tasks cannot be achieved through native resource arguments or modules.

There are two primary types of provisioners:

remote-exec Provisioner: Executes commands on a remote resource, typically after it has been provisioned.
local-exec Provisioner: Executes commands on the local machine where Terraform is being run.

Detailed Description

Remote-Exec Provisioner:

Purpose: To run commands on a remote resource, typically after it has been created. This could include updating the system, installing software, or performing other post-deployment tasks.
Key Attributes:
connection block: Defines how Terraform connects to the remote resource, usually via SSH for Linux instances.
inline or script: Specifies the commands or scripts to be executed on the remote machine.

Local-Exec Provisioner:

Purpose: To run commands locally on the machine where Terraform is executed. This is useful for tasks like logging, sending notifications, or performing local file operations after a remote resource is created.
Key Attributes:
command: Specifies the command to be executed locally.

Scenario Overview

In this scenario, you will create an EC2 instance in AWS, set up an NGINX web server on it, and manage this process using both remote-exec and local-exec provisioners. The Terraform code provided will walk you through each step of this process.

Prerequisites:

Before starting with the Terraform configuration, ensure that the following prerequisites are met:

1. AWS Configuration
Ensure that you have the AWS CLI installed and configured with your credentials.

Run the following command to configure your AWS CLI

2. VPC and Public Subnet
Ensure that you have an existing VPC and a public subnet. You can create them manually through the AWS Management Console.

Note the VPC ID and Subnet ID, as they will be required in the Terraform configuration.

3. SSH Key Generation
Generate an SSH key pair if you don’t have one already. This key will be used to SSH into the EC2 instance.
--ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
The public key will be saved in ~/.ssh/id_rsa.pub by default.

Step-by-Step Solution

Step 1: Set Up the Terraform Configuration
Start by creating a new directory for the lab and navigate to it. Inside the directory, create a file named main.tf. This file will contain the Terraform configuration.

Step 2: Provider Configuration
Begin by specifying the AWS provider, setting the region where your resources will be deployed.