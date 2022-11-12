FROM jenkins/jenkins:2.377-alpine

USER root

# Pipeline
RUN jenkins-plugin-cli -p workflow-aggregator && \
    jenkins-plugin-cli -p github && \
    jenkins-plugin-cli -p ws-cleanup && \
    jenkins-plugin-cli -p greenballs && \
    jenkins-plugin-cli -p simple-theme-plugin && \
    jenkins-plugin-cli -p kubernetes && \
    jenkins-plugin-cli -p docker-workflow && \
    jenkins-plugin-cli -p kubernetes-cli && \
    jenkins-plugin-cli -p pipeline-stage-view:2.27 && \
    jenkins-plugin-cli -p github-branch-source

# install Maven, Java, Docker, AWS
RUN apk add --no-cache maven \
    openjdk8 \
    docker \
    gettext

# Kubectl
RUN  wget https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Need to ensure the gid here matches the gid on the host node. We ASSUME (hah!) this
# will be stable....keep an eye out for unable to connect to docker.sock in the builds
# RUN delgroup ping && delgroup docker && addgroup -g 999 docker && addgroup jenkins docker

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR MINIKUBE TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
