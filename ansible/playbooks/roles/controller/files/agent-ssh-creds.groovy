import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.util.Secret

def instance = Jenkins.getInstance()
def store = instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

def existing = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
instance
).find { it.id == "agent-ssh-key" }

if (existing == null) {
println "Creating SSH key credential"

def privateKey = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    "agent-ssh-key",
    "jenkins",
    new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(
    new File("/var/lib/jenkins/.ssh/id_rsa").text
    ),
    null,
    "SSH key for connecting to agent"
)

store.addCredentials(Domain.global(), privateKey)
} else {
println "SSH credential already exists"
}