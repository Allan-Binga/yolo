# Automated Ansible Configuration Playbook

## Overview

This project sets up an automated Ansible configuration playbook that provisions a Vagrant virtual machine with the latest Ubuntu server (20.04) and deploys an e-commerce web application. The application includes a dashboard for managing retail products and provides functionality to add products via a user-friendly form.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) installed on your machine.
- [VirtualBox](https://www.virtualbox.org/) installed as the Vagrant provider.
- Basic knowledge of Ansible and Vagrant.

## Installation

1. Clone this repository:

   git clone git@github.com:Allan-Binga/yolo.git
   cd yolo

2. Initialize the Vagrant environment:

   vagrant up

3. Ensure that Ansible is installed within the VM by provisioning with the playbook. The playbook is organized as follows:
 .
├── playbook.yml                   # Main playbook file
├── roles                          # Directory containing Ansible roles
│   ├── client-rendering           # Role for client setup (e.g., Docker network, client container)
│   │   ├── tasks                  # Task files for client setup
│   │   └── vars                   # Variable files specific to client role
│   ├── docker-setup               # Role for general Docker setup
│   │   ├── tasks                  # Task files for Docker installation/configuration
│   │   └── vars                   # Variable files specific to Docker setup
│   ├── mongo-db-rendering         # Role for MongoDB setup and configuration
│   │   ├── tasks                  # Task files for MongoDB setup
│   │   └── vars                   # Variable files specific to MongoDB
│   └── server-rendering           # Role for server setup (e.g., API, backend services)
│       ├── tasks                  # Task files for server setup
│       └── vars                   # Variable files specific to server role

4. Usage:
After provisioning, the playbook will automatically run the necessary tasks to set up the application. Once complete, access the application in your web browser at:
  http://localhost:3000

5. I was able to provision up the playbook and added products listed below;
![Alt text](./images/products.png)               
