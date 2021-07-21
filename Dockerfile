FROM jenkins/jenkins:lts-jdk11

ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JENKINS_OPTS --httpPort=8080

ENV TZ America/New_York
USER root
RUN ln -fs /usr/share/zoneinfo/America/New_york /etc/localtime
USER jenkins

COPY --chown=jenkins:jenkins plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli --verbose --plugin-file /usr/share/jenkins/ref/plugins.txt

COPY --chown=jenkins:jenkins casc/* /usr/share/jenkins/ref/casc/