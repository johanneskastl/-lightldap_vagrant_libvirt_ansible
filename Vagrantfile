Vagrant.configure("2") do |config|

  # name the VMs
  config.vm.define "lldap" do |node|

    # which image to use
    node.vm.box = "opensuse/Tumbleweed.x86_64"

    # sizing of the VMs
    node.vm.provider "libvirt" do |lv|
      lv.random_hostname = true
      lv.memory = 4096
      lv.cpus = 2
    end

    # set the hostname
    node.vm.hostname = "lldap"

    # disable shared folders
    node.vm.synced_folder ".", "/vagrant", disabled: true

    # Ansible
    node.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
        ansible.limit = "all"
      ansible.playbook = "ansible/playbook-vagrant.yml"
    end # node.vm.provision

    node.trigger.after :destroy do |trigger|
      trigger.warn = "Removing ansible/group_vars/all/lldap_secret_key.yml"
      trigger.run = {inline: "rm -vf ansible/group_vars/all/lldap_secret_key.yml"}
    end # node.trigger.after

  end # config.vm.define servers

end # Vagrant.configure
