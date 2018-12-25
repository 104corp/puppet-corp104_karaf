class corp104_karaf::config inherits corp104_karaf {

  exec { 'upgrad cxf':
    provider    => 'shell',
    command     => "${corp104_karaf::install_path}/bin/karaf feature:repo-remove cxf && ${corp104_karaf::install_path}/bin/karaf feature:repo-add cxf 3.2.4",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => File['karaf'],
    refreshonly => true,
    tries       => 3,
    try_sleep   => 1,
  }

  $required_features = ['webconsole', 'cxf', 'cxf-jaxrs', 'http-whiteboard', 'http', 'cxf-jaxws', 'aries-blueprint']

  $required_features.each |String $feature| {
    exec { "install karaf feature: ${feature}":
      provider    => 'shell',
      command     => "${corp104_karaf::install_path}/bin/karaf feature:install ${feature}",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      subscribe   => File['karaf'],
      refreshonly => true,
      tries       => 3,
      try_sleep   => 1,
    }
  }
}

