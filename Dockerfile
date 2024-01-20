from jenkins/jenkins:2.441-alpine-jdk17
USER root
# Pipeline


# RUN jenkins-plugin-cli --plugins "workflow-aggregator github ws-cleanup greenballs simple-theme-plugin kubernetes docker-workflow kubernetes-cli github-branch-source" 
RUN jenkins-plugin-cli --plugins github:1.34.4 \
                                 workflow-aggregator:581.v0c46fa_697ffd \
                                 ws-cleanup:0.42 \
                                 simple-theme-plugin:103.va_161d09c38c7 \
                                 kubernetes:1.30.10 \
                                 pipeline-stage-view:2.24 \
                                 github-branch-source:1677.v731f745ea_0cf 

# install Maven, Java, Docker
RUN apk add --no-cache maven \
    openjdk17 \
    docker \
    gettext

# Kubectl
RUN     curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
