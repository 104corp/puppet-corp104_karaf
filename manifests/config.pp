class corp104_karaf::config inherits corp104_karaf {

  exec { 'update repo url':
    provider    => 'shell',
    command     => "sed -i 's/http:/https:/g' /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg ",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => File['karaf'],
    refreshonly => true,
    tries       => 3,
    try_sleep   => 1,
  }

  exec { 'remove original cxf repo':
    provider    => 'shell',
    command     => "echo \"feature:repo-remove cxf\" | ${corp104_karaf::install_path}/bin/karaf",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => Exec['update repo url'],
    refreshonly => true,
    tries       => 3,
    try_sleep   => 1,
  }

  exec { 'upgrade cxf repo to 3.2.4':
    provider    => 'shell',
    command     => "echo \"feature:repo-add cxf 3.2.4\" | ${corp104_karaf::install_path}/bin/karaf",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => Exec['update repo url'],
    refreshonly => true,
    tries       => 3,
    try_sleep   => 1,
    require     => Exec['remove original cxf repo']
  }

  $required_features = ['webconsole', 'cxf', 'cxf-jaxrs', 'http-whiteboard', 'http', 'cxf-jaxws', 'aries-blueprint', 'jndi']

  $required_features.each |String $feature| {
    exec { "install karaf feature: ${feature}":
      provider    => 'shell',
      command     => "echo \"feature:install ${feature}\" | ${corp104_karaf::install_path}/bin/karaf",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      subscribe   => Exec['update repo url'],
      refreshonly => true,
      tries       => 3,
      try_sleep   => 1,
      require     => Exec['upgrade cxf repo to 3.2.4']
    }
  }
}

