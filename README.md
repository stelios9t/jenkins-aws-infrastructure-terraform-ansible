# Jenkins Infrastructure Setup with Master-Agent Architecture on AWS

## Project Overview

This project sets up a production-style Jenkins CI/CD system on AWS using:

- **Terraform** for infrastructure provisioning (EC2, Security Groups, Key Pairs)
- **Ansible** for installing and configuring Jenkins and an SSH-based agent

## The Approach

- Used **Infrastructure-as-Code** for reproducibility
- Applied **configuration automation** (Ansible) to reduce manual setup
- Registering agents using **secure SSH and Groovy scripts**
- Demonstrating **zero-click automation**: no manual UI steps required

## Tech Stack

- **AWS EC2**
- **Terraform**
- **Ansible**
- **Groovy**

## Architecture Overview

- Two EC2 instances (controller + agent)
- Jenkins installation
- Plugin installation
- SSH key-based agent authentication
- Jenkins agent auto-registration via Groovy
- Firewall rules (UFW + Security Groups)

![architecture](docs/assets/architecture-diagram.png)

## Docs

- See [ansible.md](docs/ansible.md) for details
- See [results.md](docs/results.md) for screenshots
