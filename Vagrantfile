# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  (0..2).each do |n|
    config.vm.define "worker-#{n}" do |c|
      c.vm.hostname = "worker-#{n}"
      c.vm.network "private_network", type: "dhcp", ip: "10.240.0.0", dhcp_lower: "10.240.0.101", dhcp_upper: "10.240.0.200"

      c.vm.provision :shell, :path => "scripts/init/vagrant-setup-nodes.sh"
    end
  end

  (0..2).each do |n|
    config.vm.define "controller-#{n}" do |c|
      ip = "10.240.0.1#{n}"

      c.vm.hostname = "controller-#{n}"
      c.vm.network "private_network", ip: ip

      c.vm.provision :shell, :path => "scripts/init/vagrant-setup-nodes.sh"
    end
  end

  config.vm.define "lb-0" do |c|
    ip = "10.240.0.40"

    c.vm.hostname = "lb-0"
    c.vm.network "private_network", ip: ip

    c.vm.provision :shell, :path => "scripts/init/vagrant-setup-haproxy.sh"


    c.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
  end

end
