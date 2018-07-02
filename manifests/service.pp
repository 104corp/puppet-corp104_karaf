class corp104_karaf::service inherits corp104_karaf {
  exec {'wrap to system servicee':
    provider => 'shell',
    command  => "${corp104_karaf::install_path}/bin/client feature:install wrapper && ${corp104_karaf::install_path}/bin/shell wrapper:install && systemctl enable ${corp104_karaf::install_path}/bin/karaf.service",
    path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    unless   => 'test -e /etc/systemd/system/karaf.service && test -e /etc/systemd/system/karaf'
  }

  service { 'karaf service':
    ensure   => 'running',
    name     => 'karaf',
    provider => 'systemd',
  }
}

