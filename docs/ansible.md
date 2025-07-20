# Ansible Overview

Structure and key logic of Ansible playbooks used to provision and configure the Jenkins controller and agent on AWS EC2 instances.

## Directory Structure

```text
ansible/
├── inventory.yml
├── group_vars/
│ └── all/
│ └── vault.yml # Encrypted credentials for admin user creation
├── playbooks/
│ └── controller.yml
│ └── agent.yml
│ └── roles/
│ └──── controller/
│ └────── files/ # Contains groovy files used to bootstrap jenkins server
│ └────── handlers/ # Contains restart jenkins handler
│ └────── tasks/
│ └──────── main.yml # Contains actual steps for controller deployment
│ └──── agent/
│ └────── tasks/
│ └──────── main.yml # Contains actual steps for agent deployment
```

## Controller Role

Breakdown of each task:

- Install Java
- Add Jenkins repository key - Adds the trusted GPG key used to validate Jenkins package integrity. Like a signature check.
- Install Jenkins
- Ensure Jenkins is running (systemd check)
- Allow firewall ports (opens ports 22 for SSH and 8080 for HTTP)
- Enable systemd ufw service to control routes
- Download Jenkins CLI tool
- Wait for Jenkins to be ready - Checks if jenkins is loaded by proving the UI /login route
- Create directory for init scripts
- Create default admin user - Uses basic-security.groovy and automates the admin user creation of jenkins
- Set Jenkins URL - Uses set-url.groovy to ensure URL is set so that email notifications and links in Jenkins UI work correctly
- Force Restart Jenkins to apply admin user creation
- Wait for Jenkins to be ready after admin setup
- Copy SSH private key to controller - Copies the local SSH private key to the controller EC2 machine so that it can be passed to the agent for SSH-based authentication later. The key value pairs were generated with the below command:

```bash
ssh-keygen -t rsa -b 4096 -f jenkins-key
```

- Create .ssh directory for Jenkins user - Required as proccesses will be running as Jenkins user
- Copy private key to Jenkins home
- Install Jenkins plugins using CLI - Uses CLI tool installed earlier and authenticates using ansible-vault credentials to install plugins
- Deploy SSH-based agent auto-registration Groovy script - Uses agent-ssh.groovy reates a new agent based off the second EC2 machine IP
- Create SSH credentials for agent in Jenkins - Uses agent-ssh-creds.groovy and creates Jenkins credentials so that the Jenkins agent can authenticate to the controller using SSH and execute workload.
- Restart Jenkins to apply Groovy scripts

## Agent Role

Breakdown of each task:

- Install Java
- Create Jenkins user - Linux level
- Set up authorized SSH key for jenkins user - So that jenkins user in agent machine can authenticate to the controller
- Force Restart Jenkins to apply new agent
