## Explanation of Project Structure and Execution
This document provides a detailed explanation of the configuration and execution logic for this project, focusing on the playbook.yml file in Ansible and the main.tf file in Terraform. Each component's role and order are justified to achieve an efficient and organized deployment of the application.

# Overview
The configuration involves two main infrastructure automation tools:

1. Ansible - for server configuration, application setup, and deployment.
2. Terraform - for virtual machine provisioning through the Vagrant provider, ensuring that Ansible has a suitable environment for execution.

# Order of Execution in the Ansible Playbook
The playbook (playbook.yml) defines a sequence of roles, each responsible for a specific aspect of the server setup and application deployment. Since Ansible executes tasks sequentially, the order in which roles are run is critical for a successful deployment.

# Breakdown of Roles and Their Positioning
1. docker-setup
Purpose: The docker-setup role is responsible for ensuring that Docker is correctly installed and configured on the server.
Reason for Positioning: This role is executed first because Docker provides the underlying environment in which the application and database containers will run. Without Docker, subsequent roles cannot complete their tasks.
Modules Used: Common modules in this role may include apt or yum (for package installation) and service (for starting the Docker service).

2. client-rendering
Purpose: The client-rendering role handles the setup of the front-end container for the application.
Reason for Positioning: This role is run after Docker is set up to ensure that the application’s client-side service is properly containerized. It prepares the client interface, making it accessible as soon as the server and database are configured.
Modules Used: Modules used may include docker_container (to manage the client container) and copy (for copying configuration files).

3. mongo-db-rendering
Purpose: This role configures and deploys the MongoDB container, which serves as the database backend for the application.
Reason for Positioning: Positioned here to ensure that the database is operational before the server starts, allowing the server to establish a connection with MongoDB immediately on startup.
Modules Used: The docker_container module is used to pull and run the MongoDB Docker image, while lineinfile might be used for configuration adjustments.

4. server-rendering
Purpose: The server-rendering role sets up and starts the application server container.
Reason for Positioning: This is the final role in the sequence, allowing it to connect to both the client and MongoDB services. The server must come up last to ensure it has access to the necessary resources.
Modules Used: Modules likely include docker_container (to manage the server container) and template (for server configuration).

## Terraform Configuration
The main.tf file in Terraform provides a provisioning setup that uses Vagrant as the provider, allowing for consistent VM creation and management.

# Vagrant Provider
- Purpose: The Vagrant provider (bmatcuk/vagrant) initializes a VM environment compatible with the Ansible playbook.
- Configuration Details: The vagrant_vm resource points to the root directory of the Vagrantfile (vagrantfile_dir = "../"), setting up the VM locally for Ansible provisioning.
# Ansible Provisioning Using Null Resource
- Purpose: The null_resource executes the Ansible playbook (playbook.yml) on the VM created by Vagrant.
- Configuration Details: By including a dependency on vagrant_vm.simple_vm, the provisioning is triggered only after the VM is ready. The provisioner command utilizes the sensitive variable password (defined in vars.tf) to authenticate during the Ansible playbook execution.