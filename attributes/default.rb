default["poweradmin"]["remote_install"] = true
default["poweradmin"]["version"] = '2.1.7'
default["poweradmin"]["remote_url"] = "http://downloads.sourceforge.net/project/poweradmin/poweradmin-#{node["poweradmin"]["version"]}.tgz"
default["poweradmin"]["package_name"] = 'poweradmin-2.1.7.tgz'
default["poweradmin"]["install_dir"] = '/var/www/poweradmin'
default["poweradmin"]["http_port"] = '80'

default["poweradmin"]["hostname"] = 'localhost'
default["poweradmin"]["port"] = 3306
default["poweradmin"]["username"] = 'powerdns'
default["poweradmin"]["password"] = 'p4ssw0rd'
default["poweradmin"]["dbname"] = 'powerdns'
default["poweradmin"]["type"] = 'mysql'

default["apache"]["listen_ports"] = ["#{node["poweradmin"]["http_port"]}"]

default['apache']['default_modules'] = %w[status alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex dir env mime negotiation setenvif php5 log_config logio]
