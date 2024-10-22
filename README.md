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

Step 3: Create an SSH Key Pair
Create a new SSH key pair, or use an existing one, to authenticate access to the EC2 instance

The aws_key_pair resource creates a new key pair using an existing public key (~/.ssh/id_rsa.pub). The key pair will be used for SSH access to the EC2 instance.

Step 4: Define a Security Group
Create a security group that allows SSH and HTTP traffic to the EC2 instance.

This aws_security_group resource defines a security group allowing inbound SSH (port 22) and HTTP (port 80) traffic from any IP address. The egress rule allows all outbound traffic. Use your own VPC ID.


Step 5: Provision an EC2 Instance
Deploy an EC2 instance with the specified security group, subnet, and key pair, and use provisioners to manage the server.

This aws_instance resource creates an EC2 instance using a specific AMI and instance type (t2.micro). The instance is launched in a specified subnet with the security group created earlier. The associate_public_ip_address = true ensures that the instance gets a public IP address.


Step 6: Execute Commands with Remote-Exec Provisioner
Use the remote-exec provisioner to update the server, install NGINX, and start the service.

The remote-exec provisioner connects to the EC2 instance via SSH using the ubuntu user and the private key. It then runs a series of commands to update the server, install NGINX, and start the web server.

Step 7: Log Output with Local-Exec Provisioner
Use the local-exec provisioner to log the public IP of the instance locally.

The local-exec provisioner runs a command on your local machine that logs the public IP of the EC2 instance into a file called instance_ip.txt.

Step 8: Clean Up with Destroy Provisioners
Use remote-exec and local-exec provisioners to stop and remove NGINX when the instance is destroyed.

The when = "destroy" argument in both remote-exec and local-exec provisioners ensures that these commands are executed before the resource is destroyed. The remote commands stop and remove NGINX, while the local command logs that the instance has been destroyed.

Step 9: Applying the Configuration
To apply the Terraform configuration, follow these steps:

Initialize the Terraform working directory:

terraform init
Validate the configuration to check for errors:

terraform validate
Apply the configuration to create the resources:

terraform apply
Review the plan output and confirm the apply by typing yes.

Check the output to ensure the provisioners have run successfully and that the EC2 instance is set up with NGINX.

Conclusion
Provisioners in Terraform provide a flexible way to execute scripts or commands both locally and remotely, adding additional configuration steps to your infrastructure as code process. In this lab, we demonstrated how to use both remote-exec and local-exec provisioners to automate the setup and teardown of an NGINX.