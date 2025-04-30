Vagrant.configure("2") do |config|
  config.vm.box = "bento/rockylinux-9.5"
  config.vm.box_version = "202502.21.0"
  config.vm.hostname = "microservice"
  config.vm.network "private_network", ip: "192.168.56.10"
  config.vm.synced_folder ".", "/vagrant", type: "rsync"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provider "parallels" do |prl|
    prl.memory = 2048
    prl.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo dnf install -y epel-release
    sudo dnf install -y python3 python3-pip
  SHELL
end
