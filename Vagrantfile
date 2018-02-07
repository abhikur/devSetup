VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?('vagrant-env')
    config.env.enable
  end
  config.vm.box = 'centos/7'

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    config.cache.enable :gem
    config.cache.auto_detect = true
    config.cache.synced_folder_opts = {
        type: :nfs,
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  config.ssh.forward_agent = true

  if ENV['PAM_FORWARD_DISPLAY_ON_HOST']
    config.ssh.forward_x11 = true
  end

  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  require_relative './tasks/repositories'
  config.vm.synced_folder '.', '/home/vagrant/infra', type: 'nfs'

  Repositories::ALL.each do |repo|
    config.vm.synced_folder "../#{repo}", "/#{repo}", type: 'nfs'
    config.bindfs.bind_folder "/#{repo}", "/home/vagrant/#{repo}",
                              perms: "u=rwx:g=rw:o=rwx",
                              create_as_user: true
  end
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  config.vm.define :dev do |cm_config|
    cm_config.vm.network :forwarded_port, guest: 5432, host: 5432
    cm_config.vm.network :forwarded_port, guest: 4097, host: 4097
    cm_config.vm.network :forwarded_port, guest: 3000, host: 3000
    cm_config.vm.network :forwarded_port, guest: 6379, host: 6379
    cm_config.vm.network :forwarded_port, guest: 6382, host: 6382
    cm_config.vm.network :forwarded_port, guest: 8089, host: 8089
    cm_config.vm.network :forwarded_port, guest: 9000, host: 9000
    cm_config.vm.network :forwarded_port, guest: 9089, host: 9089
    cm_config.vm.network :forwarded_port, guest: 9090, host: 9090
    cm_config.vm.network :forwarded_port, guest: 9097, host: 9097
    cm_config.vm.network :forwarded_port, guest: 9080, host: 9080
    cm_config.vm.network :forwarded_port, guest: 7777, host: 7777

    cm_config.vm.network :private_network, ip: '192.168.20.22'

    config.vm.provision "ansible" do |ansible|
      ansible.inventory_path = "inventory"
      ansible.limit = "devbox"
      ansible.playbook = "playbook.yml"
    end

    config.vm.provider 'virtualbox' do |v|
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--memory', (ENV['PAM_VM_MEMORY'] || 6144).to_i]
      v.customize ['modifyvm', :id, '--cpus', (ENV['PAM_VM_CPU'] || 4).to_i]
    end

  end
end
