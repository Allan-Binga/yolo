## Project Deployment with Ansible and Terraform

# Project Structure
- playbook.yml: Ansible playbook defining the order of roles for configuring the application server.
- main.tf: Terraform configuration file to set up a VM using Vagrant.
- vars.tf: Contains Terraform variables, including sensitive information like passwords.

# Requirements
- Ansible: For configuration management.
- Terraform: To provision and manage the VM.
- Vagrant: To create and manage virtual machines.
- Docker: Required on the provisioned server to run application containers.

# Setup Instructions
Clone the repository to your local machine:
```bash
        git clone git@github.com:Allan-Binga/yolo.git
```
Navigate to the root directory:
```bash
        cd yolo
```
Checkout into Stage_two branch:
```bash
        git checkout Stage_two
```

# Install dependencies:

Install Ansible
Install Terraform
Install Vagrant
Configure sensitive information in vars.tf:


# Execution
Run Terraform:

From the project root, initialize and apply Terraform configuration to provision the VM:

```bash
        terraform init
        terraform apply
```

# Run Ansible Playbook:

Ansible will automatically execute the playbook.yml file on the provisioned VM to configure and deploy the application.

# Role Descriptions
The roles in playbook.yml are executed sequentially, with each role performing a specific function necessary for the deployment.

1. docker-setup:
Installs and configures Docker, which is required for the subsequent roles.

2. client-rendering:
Sets up the front-end application container. Configures the client-side service to connect with the server and MongoDB.

3. mongo-db-rendering:
Configures and runs the MongoDB container for persistent data storage. This role ensures the database is ready before the server connects.

4. server-rendering:
Deploys the server application container, which interacts with both the client and MongoDB. This is run last to ensure all dependencies are available.

# Terraform Configuration
The Terraform setup uses the Vagrant provider to create a virtual machine. Here’s a breakdown of the key components in main.tf:

Vagrant Provider: Defines the bmatcuk/vagrant provider to manage VM creation.
vagrant_vm Resource: Points to the Vagrantfile and creates the VM locally.
null_resource: Runs the Ansible playbook on the VM after provisioning, using local-exec to call the playbook with the required password variable.