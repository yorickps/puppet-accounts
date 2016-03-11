require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

UNSUPPORTED_PLATFORMS = ['Suse','windows','AIX','Solaris']

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    #install_puppet
    #on host, 'gem install hiera'
    #install_librarian

    puppet_module_install(:source => proj_root, :module_name => 'accounts')
    hosts.each do |host|
      #on host, 'gem install bundler'
      #on host, 'cd /etc/puppet && bundle install --without development'
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'deric-gpasswd'), { :acceptable_exit_codes => [0,1] }
      #binding.pry
    end
  end
end