Docker box for vagrant

This docking image(based on ubuntu 18) is for use with vagrant as a base box,
It contains the minimum as openssh for the ssh connection, the credentials are: 

    vagrant:vagrant 

and do not require a password with sudo, this base box is very similar to a box made with packer

packages for install:

    openssh-server wget lsb-release sudo nano ranger

for build:

    docker buitl -t <name> .

for get image from docker hub

    docker pull docker_box