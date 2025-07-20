# Provisioning Results

## Jenkins UI

Jenkins is accessible on port `8080` and shows the dashboard screen.

![Jenkins UI](assets/jenkins-ui.png)

---

## Agent Node Online

📸 The `Manage Jenkins → Nodes` page confirms that the SSH agent `agent1` is online and ready.

![Jenkins Agent](assets/jenkins-ui-agent.png)

---

## EC2 Instances

📸 AWS EC2 dashboard shows both `controller` and `agent` instances running with security groups attached.

![EC2 Instances](assets/ec2-dashboard.png)

---

## Terminal Output

Ansible provisioned Jenkins controller:

![Ansible Controller](assets/jenkins-controller-output.png)

Ansible provisioned Jenkins agent:

![Ansible Agent](assets/agent-output.png)

---

## SSH Credential in Jenkins

📸 Jenkins > Credentials includes an SSH key configured for agent communication and created automatically through the playbook using the groovy init script.

![Jenkins SSH Credential](assets/agent-ssh-key.png)

---
