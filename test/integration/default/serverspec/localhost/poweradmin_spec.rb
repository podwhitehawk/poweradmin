require 'spec_helper'

if ['debian', 'ubuntu'].include?(os[:family])
  describe package('apache2') do
    it { should be_installed }
  end
  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end
  describe package('libapache2-mod-php5') do
    it { should be_installed }
  end
elsif os[:family] == 'redhat'
  describe package('httpd') do
    it { should be_installed }
  end
  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end
  describe package('php') do
    it { should be_installed }
  end
end

describe port(80) do
  it { should be_listening }
end

if ['debian', 'ubuntu'].include?(os[:family])
  describe file('/etc/apache2/ports.conf') do
    it { should be_file }
    it { should contain 'Listen *:80' }
  end
elsif os[:family] == 'redhat'
  describe file('/etc/httpd/ports.conf') do
    it { should be_file }
    it { should contain 'Listen *:80' }
  end
end


describe file('/var/www/poweradmin/inc/config.inc.php') do
  it { should be_file }
end

if ['debian', 'ubuntu'].include?(os[:family])
  describe file('/var/www/poweradmin') do
    it { should be_directory }
    it { should be_owned_by 'www-data' }
    it { should be_mode 750 }
  end
elsif os[:family] == 'redhat'
  describe file('/var/www/poweradmin') do
    it { should be_directory }
    it { should be_owned_by 'apache' }
    it { should be_mode 750 }
  end
end

describe file('/var/www/poweradmin/install') do
  it { should_not be_directory }
end

if ['debian', 'ubuntu'].include?(os[:family])
  describe file('/etc/apache2/sites-enabled/poweradmin.conf') do
    it { should be_file }
    it { should contain 'DocumentRoot /var/www/poweradmin' }
  end
elsif os[:family] == 'redhat'
  describe file('/etc/httpd/sites-enabled/poweradmin.conf') do
    it { should be_file }
    it { should contain 'DocumentRoot /var/www/poweradmin' }
  end
end
