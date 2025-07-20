import jenkins.model.*
def jlc = JenkinsLocationConfiguration.get()
jlc.setUrl("http://{{ ansible_host }}:8080")
jlc.save()