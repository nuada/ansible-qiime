FROM ubuntu:14.04
MAINTAINER Piotr Radkowski <piotr.radkowski@uj.edu.pl>

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Install ansible
RUN apt-get update && \
	apt-get install -y software-properties-common curl && \
	apt-add-repository -y ppa:ansible/ansible && \
	apt-get update && \
	apt-get install -y ansible

# Setup ansible roles
ENV ANSIBLE_HOME /etc/ansible
RUN mkdir -p ${ANSIBLE_HOME}/roles/nuada.dockerize; \
	curl --location https://github.com/nuada/ansible-dockerize/archive/master.tar.gz | \
	tar xz -C ${ANSIBLE_HOME}/roles/nuada.dockerize --strip 1
RUN mkdir -p ${ANSIBLE_HOME}/roles/nuada.qiime
ADD defaults ${ANSIBLE_HOME}/roles/nuada.qiime/defaults
ADD handlers ${ANSIBLE_HOME}/roles/nuada.qiime/handlers
ADD tasks ${ANSIBLE_HOME}/roles/nuada.qiime/tasks
ADD templates ${ANSIBLE_HOME}/roles/nuada.qiime/templates

# Playbook
ADD site.yml ${ANSIBLE_HOME}/site.yml
RUN ansible-playbook ${ANSIBLE_HOME}/site.yml

# vsearch wrapper
ADD usearch61 /usr/bin/usearch61

ENV QIIME_CONFIG_FP /usr/local/etc/qiime_config
ENV HOME /home/qiime
WORKDIR ${HOME}
USER qiime

CMD bash
