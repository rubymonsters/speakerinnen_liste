# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "web" do |config|
    config.vm.box = "ubuntu/xenial64"
    config.vm.hostname = "web"
    config.ssh.forward_agent = true

    # Insecure vagrant key to get root privilege
    config.ssh.insert_key = false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP (if this ip is already used on your machine, change to another one).
    config.vm.network "private_network", ip: "192.168.33.53"

    # Share an additional folder from host to the guest VM. NFS is used here to speed up the
    # performance while sharing content between host and guest machine.
    config.vm.synced_folder ".", "/vagrant", type: "nfs"

    config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      # vb.gui = true

      # Customize the amount of memory on the VM:
      vb.memory = "1024"
      vb.cpus = "2"
    end

    # Enable provisioning with a shell script. Additional provisioners such as
    # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    # config.vm.provision "shell", inline: <<-SHELL
    #  apt-get update
    # apt-get install -y apache2
    # SHELL

    # config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
    # config.vm.provision "shell", path: 'install.sh'
  end
end
