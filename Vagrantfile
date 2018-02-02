VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/artful64"
  config.vm.provision"shell", inline: "sudo resize2fs /dev/sda1" # use whole disk
  config.vm.provision"shell", inline: "sudo apt-get update"
  config.vm.provision"shell", inline: "sudo apt-get -y dist-upgrade"
  config.vm.provision"shell", inline: "sudo apt-get -y install docker-compose"
  config.vm.provision"shell", inline: "sudo usermod -aG docker vagrant"
end
