class corp104_karaf::service inherits corp104_karaf {
  exec {'wrap to system servicee':
    provider  => 'shell',
    command   => "cd ${corp104_karaf::install_path}/bin/contrib && ./karaf-service.sh -k /opt/karaf -n karaf && cp ${corp104_karaf::install_path}/bin/contrib/karaf.service /etc/systemd/system/",
    path      => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    unless    => 'test -e /etc/systemd/system/karaf.service',
    tries     => 3,
    try_sleep => 1,
  }

  service { 'karaf service':
    ensure   => 'running',
    name     => 'karaf',
    provider => 'systemd',
    enable   => true,
  }
}

