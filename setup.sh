#! /bin/bash

docker_compose_version="1.8.0"

function announce() {
	echo ""
	echo $@
}

announce "Overwriting .bashrc symlink with a copy of the source .bashrc file, so it can be extended..."
cp /usr/share/skel/.bashrc /home/core/.bashrc.new
mv /home/core/.bashrc.new /home/core/.bashrc
announce "Finished overwriting .bashrc symlink."

announce "Installing docker-compose version ${docker_compose_version}..."
mkdir -p /opt/bin
curl --progress-bar -s -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m` > /opt/bin/docker-compose
chmod +x /opt/bin/docker-compose
announce "Finished installing docker-compose."

announce "Enabling bash-completion for Docker and Docker-Compose..."
toolbox dnf update --verbose --assumeyes
toolbox dnf install --verbose --assumeyes bash-completion
toolbox curl --create-dirs -L https://raw.githubusercontent.com/docker/docker/v$(docker version -f '{{.Client.Version}}')/contrib/completion/bash/docker -o /usr/share/bash-completion/completions/docker
toolbox curl --create-dirs -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /usr/share/bash-completion/completions/docker-compose
toolbox cp /usr/share/bash-completion /media/root/var/ -R
source /var/bash-completion/bash_completion
echo 'source /var/bash-completion/bash_completion' >> /home/core/.bashrc
announce "Finished enabling bash-completion."

announce "Finished setup."
