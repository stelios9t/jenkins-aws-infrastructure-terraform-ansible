import jenkins.model.*
import hudson.plugins.sshslaves.*
import hudson.slaves.*
import hudson.model.*
import java.util.Collections

def agentName = "agent1"
def agentHome = "/home/jenkins"
def agentHost = "{{ hostvars['agent1']['ansible_host'] }}"
def credentialsId = "agent-ssh-key"

println "Checking for existing agent"
def instance = Jenkins.getInstance()

if (instance.getNode(agentName) == null) {
    println "Creating SSH-based agent"

    def launcher = new SSHLauncher(agentHost, 22, credentialsId, null, null, null, null, 10, 10, 60, null)

    def agent = new DumbSlave(
        agentName,
        "Automatically created agent",
        agentHome,
        "1",
        Node.Mode.NORMAL,
        "linux-agent",
        launcher,
        new RetentionStrategy.Always(),
        Collections.emptyList()
    )

    instance.addNode(agent)
    println "Agent created."
} else {
    println "Agent already exists."
}