# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  # must be at the top
  config.vm.define "lb-0" do |c|
      ip = "10.240.0.40"

      c.vm.hostname = "lb-0"
      c.vm.network "private_network", ip: ip

      c.vm.provision :shell, :inline => "sudo ip addr flush dev eth1"
      c.vm.provision :shell, :inline => "sudo ip addr add #{ip}/24 dev eth1"

      c.vm.provision :shell, :path => "scripts/init/vagrant-setup-haproxy.sh"


      c.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
  end

  (0..2).each do |n|
    config.vm.define "controller-#{n}" do |c|
        ip = "10.240.0.1#{n}"

        c.vm.hostname = "controller-#{n}"
        c.vm.network "private_network", ip: ip

        c.vm.provision :shell, :inline => "sudo ip addr flush dev eth1"
        c.vm.provision :shell, :inline => "sudo ip addr add #{ip}/24 dev eth1"
        c.vm.provision :shell, :inline => "sudo swapoff -a"
        c.vm.provision :shell, :inline => "sed -i -e '/swap/d' /etc/fstab"
        c.vm.provision :shell, :path => "scripts/init/vagrant-setup-hosts-file.sh"

        c.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
        end
    end
  end

  (0..2).each do |n|
    config.vm.define "worker-#{n}" do |c|
        ip = "10.240.0.2#{n}"

        c.vm.hostname = "worker-#{n}"
        c.vm.network "private_network", ip: ip

        c.vm.provision :shell, :inline => "sudo ip addr flush dev eth1"
        c.vm.provision :shell, :inline => "sudo ip addr add #{ip}/24 dev eth1"
        c.vm.provision :shell, :inline => "sudo swapoff -a"
        c.vm.provision :shell, :inline => "sed -i -e '/swap/d' /etc/fstab"
        c.vm.provision :shell, :path => "scripts/init/vagrant-setup-hosts-file.sh"
    end
  end

end
