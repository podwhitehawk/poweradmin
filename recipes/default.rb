#
# Cookbook Name:: poweradmin
# Recipe:: default
#
# Copyright (C) 2014 SiruS (https://github.com/podwhitehawk)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if platform_family?("rhel")
  include_recipe "yum-epel"
elsif platform_family?("debian")
  include_recipe "apt"
end
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe 'database::mysql'

value_for_platform_family(
       "rhel" => ["php-mcrypt", "php-mysql"],
       "debian" =>  ["php5-mcrypt", "php5-mysql"]
  ).each do |pkg|
  package pkg do
    action :install
  end
end

owner_group = value_for_platform_family(
    "debian" => "www-data",
    "rhel" => "apache"
  )

directory node["poweradmin"]["install_dir"] do
  owner owner_group
  group owner_group
  mode 0750
  action :create
end

if node["poweradmin"]["remote_install"]
  tar_extract node["poweradmin"]["remote_url"] do
    target_dir node["poweradmin"]["install_dir"]
    creates "#{node["poweradmin"]["install_dir"]}/inc/config-me.inc.php"
    tar_flags [ '--strip-components 1' ]
  end
else
  cookbook_file node["poweradmin"]["package_name"] do
    path "/tmp/#{node["poweradmin"]["package_name"]}"
    action :create_if_missing
  end
  tar_extract "/tmp/#{node["poweradmin"]["package_name"]}" do
    action :extract_local
    target_dir node["poweradmin"]["install_dir"]
    creates "#{node["poweradmin"]["install_dir"]}/inc/config-me.inc.php"
    tar_flags [ '--strip-components 1' ]
  end
end

directory "#{node["poweradmin"]["install_dir"]}/install" do
  recursive true
  action :delete
end

# setup mysql connection
mysql_connection_info = {
  :host => node["poweradmin"]["hostname"],
  :username => node["poweradmin"]["username"],
  :password => node["poweradmin"]["password"]
}

template "#{node["poweradmin"]["install_dir"]}/inc/config.inc.php" do
  source "config.inc.php.erb"
  variables('session_key' => rand(36**64).to_s(36))
  action :create_if_missing
end

# import from a dump files
mysql_database "poweradmin_import_sql_dump" do
  connection mysql_connection_info
  database_name node["poweradmin"]["dbname"]
  sql { ::File.open("#{node["poweradmin"]["install_dir"]}/sql/poweradmin-mysql-db-structure.sql").read }
  not_if {File.exists?("/etc/.poweradmin_sql.imported")}
  action :query
end

#marker for sql import
file "/etc/.poweradmin_sql.imported"

# update admin password
mysql_database "update_admin_password" do
  connection mysql_connection_info
  database_name node["poweradmin"]["dbname"]
  sql "update users set password = '#{getMD5pass?}' where username = 'admin'"
  action :query
end

web_app "poweradmin" do
  server_name node['hostname']
  server_port node["poweradmin"]["http_port"]
  cookbook 'apache2'
  docroot node["poweradmin"]["install_dir"]
end
