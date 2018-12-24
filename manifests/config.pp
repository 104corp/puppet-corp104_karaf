class corp104_karaf::config inherits corp104_karaf {
  exec { 'start karaf':
    provider => 'shell',
    command  => "${corp104_karaf::install_path}/bin/start",
    path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    unless   => 'test -e /opt/karaf/karaf.pid',
  }

  exec { 'wait karaf start up complete':
    provider    => 'shell',
    command     => 'fuser 44444/tcp && fuser 8101/tcp',
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    tries       => 20,
    try_sleep   => 1,
    subscribe   => Exec['start karaf'],
    refreshonly => true,
  }

  exec { 'upgrad cxf':
    provider    => 'shell',
    command     => "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && ${corp104_karaf::install_path}/bin/client feature:repo-remove cxf && ${corp104_karaf::install_path}/bin/client feature:repo-add cxf 3.2.4",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => Exec['start karaf'],
    refreshonly => true,
  }


  # Puppet would only install required features at the first startup of karaf
  # That means if karaf  starteed, Puppet would not install any feature even if add new feature to array $required_features
  $required_features = ['webconsole', 'cxf', 'cxf-jaxrs', 'http-whiteboard', 'http', 'cxf-jaxws', 'aries-blueprint']

  $required_features.each |String $feature| {
    exec { "install karaf feature: ${feature}":
      provider    => 'shell',
      command     => "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && ${corp104_karaf::install_path}/bin/client feature:install ${feature}",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      subscribe   => Exec['start karaf'],
      refreshonly => true,
      tries       => 3,
      try_sleep   => 1,
    }
  }

  exec { 'stop karaf':
    provider    => 'shell',
    command     => "${corp104_karaf::install_path}/bin/stop",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => Exec['start karaf'],
    refreshonly => true,
  }
}

