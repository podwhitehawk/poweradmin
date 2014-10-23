name             'poweradmin'
maintainer       'SiruS'
maintainer_email 'https://github.com/podwhitehawk'
license          'Apache 2.0'
description      'Installs/Configures poweradmin'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.4'

depends 'apt'
depends 'yum-epel'
depends 'apache2'
depends 'tar'
depends 'database'
depends 'chef-pdns'

supports 'centos'
supports 'ubuntu'
supports 'debian'
