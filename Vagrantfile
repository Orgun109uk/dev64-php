# PHP Development VM
# Requires Vagrant 1.7.2+

Vagrant.configure("2") do |config|

  config.vm.box = "dev64-php"
  config.vm.box_url = "./data/dev64-php.virtualbox.box"

  config.ssh.forward_agent = true

  config.vm.network "private_network", ip: "192.168.200.101"

  config.vm.synced_folder "workspace", "/home/vagrant/workspace", create: true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/workspace", "1"]
  end

  config.vm.network "public_network"
  config.vm.usable_port_range = (10200..10500)

  config.vm.provision :shell, path: "./data/scripts/vagrant/startup.sh", run: "always"
end
