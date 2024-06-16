  GNU nano 7.2                                                                                                                                           docker-setup.sh                                                                                                                                                    
#!/bin/bash

### Script for configuration of Docker and Portainer for Debian-based systems (Debian, Ubuntu, Raspbian) ###
### This script must be run as root ###

# REF:https://docs.docker.com/engine/install/debian/#install-using-the-repository 

# Install pre-requisite packages
echo "Installing required packages"
sleep 2
apt install -y vim git gpg apt-transport-https ca-certificates curl software-properties-common
sleep 2

# Install Tailscale
echo "Installing Tailscale
sleep 2
curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt-get install tailscale
tailscale up
sleep 2

# Add Docker's official GPG key:
echo "Adding Docker repo GPG key"
sleep 2
apt-get update -y && \
install -m 0755 -d /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
chmod a+r /etc/apt/keyrings/docker.gpg 
sleep 2

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install Docker and dependencies
echo "Installing Docker and dependencies"
sleep 2
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
docker run hello-world && \
systemctl enable docker
sleep 2

# Install and run Portainer
echo "Installing Portainer"
sleep 2
docker volume create portainer && \
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
sleep 2

