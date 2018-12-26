class corp104_karaf::config inherits corp104_karaf {

  exec { 'remove original cxf repo':
    provider    => 'shell',
    command     => "echo \"feature:repo-remove cxf\" | ${corp104_karaf::install_path}/bin/karaf",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => File['karaf'],
    refreshonly => true,
    tries       => 3,
    try_sleep   => 1,
  }

  exec { 'upgrade cxf repo to 3.2.4':
    provider    => 'shell',
    command     => "echo \"feature:repo-add cxf 3.2.4\" | ${corp104_karaf::install_path}/bin/karaf",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => File['karaf'],
    refreshonly => true,
    tries       => 3,
    try_sleep   => 1,
    require     => Exec['remove original cxf repo']
  }

  $required_features = ['webconsole', 'cxf', 'cxf-jaxrs', 'http-whiteboard', 'http', 'cxf-jaxws', 'aries-blueprint']

  $required_features.each |String $feature| {
    exec { "install karaf feature: ${feature}":
      provider    => 'shell',
      command     => "echo \"feature:install ${feature}\" | ${corp104_karaf::install_path}/bin/karaf",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      subscribe   => File['karaf'],
      refreshonly => true,
      tries       => 3,
      try_sleep   => 1,
      require     => Exec['upgrade cxf repo to 3.2.4']
    }
  }
}

