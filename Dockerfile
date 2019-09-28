FROM ubuntu
MAINTAINER Jose Luis Blas Ralde "joseluisbr2049@gmail.com"

ENV HOME /root

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

#install packages
RUN apt-get update
RUN apt-get install -y openssh-server wget lsb-release sudo nano systemd ranger

#EXPOSE 22
RUN mkdir -p /var/run/sshd
RUN chmod 0755 /var/run/sshd

# Create and configure vagrant user
RUN useradd --create-home -s /bin/bash vagrant
WORKDIR /home/vagrant

# Configure SSH access
RUN mkdir -p /home/vagrant/.ssh
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUGuJ4YU7pfZvQfbcap/neafPUajx6ZCH6+Gv+1qhdkerE6S75L36xLGrguxA547QOXAFZtFJiC9905paSqAfuLGYpDXVb4P/qzBkkYIvV8rGE7DZjoRGFazBQvpdo8qRvYxGfYwrZ2tXCDx68f6gZLfN/COQwUcMwZXZUJ+lQL8bqiWIWVRMsZwObIlVAZAeOWKj0uyJUc7fSHasbPTuRL8EwEo1A751bbf7gP6c7+a368GfISKZyKel4H7g7d3RBngcJ/ZDb667BqCNKZP3Y3iyWfXsGKuD7GvWlKf7vg7Z+LK/46dx7Mam3cUzkEeQUyNKhGdYb0AjhVt+cjpMZ vagrant" > /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant: /home/vagrant/.ssh
RUN echo -n 'vagrant:vagrant' | chpasswd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Enable passwordless sudo for the "vagrant" user
RUN mkdir -p /etc/sudoers.d
RUN install -b -m 0440 /dev/null /etc/sudoers.d/vagrant
RUN echo 'vagrant ALL=NOPASSWD: ALL' >> /etc/sudoers.d/vagrant

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Clean up APT when done.

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
