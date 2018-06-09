Vagrant.configure('2') do |config|
  # TODO: Update to Stretch.
  #config.vm.box = 'debian/stretch64'
  config.vm.box = 'debian/jessie64'
  # TODO: Not needed unless wanting to attempt to clone git repositories with Salt.
  #config.ssh.forward_agent = true
  Dir.mkdir('tmp') unless File.exist?('tmp')

  if File.exist?('tmp/ethernet-device.txt')
    bridge = File.read('tmp/ethernet-device.txt').chomp
  else
    if RbConfig::CONFIG['host_os'] =~ /mswin32|mingw32/
      bridge = 'Ethernet'
    else
      bridge = 'eth0'
    end

    File.write('tmp/ethernet-device.txt', bridge + "\n")
  end

  if not File.exist?('tmp/hostname.txt')
    File.write('tmp/hostname.txt', "jt\n")
  end

  config.vm.network :public_network, bridge: bridge
  config.vm.network :private_network, ip: '192.168.42.3'

  if RbConfig::CONFIG['host_os'] =~ /mswin32|mingw32/
    mount_type = 'virtualbox'
  else
    mount_type = 'nfs'
  end

  config.vm.synced_folder '.', '/vagrant', type: mount_type
  config.vm.synced_folder 'salt-provisioning', '/srv/salt', type: mount_type

  config.vm.provider :virtualbox do |v|
    v.name = 'jenkins-tools'
    v.cpus = 2
    v.memory = 2048
  end

  # TODO: This does not work as intended.
  #config.vm.provision :shell, path: 'script/vagrant/reconfigure-locales.sh'
  config.vm.provision :shell, path: 'script/vagrant/update-system.sh'
  # TODO: Decide whether to use this or get rid of it because Salt is doing everything.
  #config.vm.provision :shell, path: 'script/vagrant/provision.sh'

  config.vm.provision :shell do |command|
    hostname = File.read('tmp/hostname.txt').chomp
    domain = File.read('tmp/domain.txt').chomp
    command.path = 'tmp/bootstrap-salt.sh'
    # Jessie versions https://repo.saltstack.com/apt/debian/8/amd64
    # Stretch versions https://repo.saltstack.com/apt/debian/9/amd64
    command.args = ['-U', '-i', hostname + '.' + domain, '-c', '/vagrant/tmp/salt', 'stable', '2018.3.0']
  end

  config.vm.provision :shell, path: 'script/vagrant/highstate.sh'
end

# vim: ft=ruby
