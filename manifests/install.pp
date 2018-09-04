class corp104_karaf::install inherits corp104_karaf {

  $karaf_download_url ="http://www-eu.apache.org/dist/karaf/${corp104_karaf::version}/apache-karaf-${corp104_karaf::version}.tar.gz"
  $karaf_sha512sum_url = "https://www.apache.org/dist/karaf/${corp104_karaf::version}/apache-karaf-${corp104_karaf::version}.tar.gz.sha512"
  $karaf_download_path = "${corp104_karaf::tmp_path}/apache-karaf-${corp104_karaf::version}.tar.gz"
  $karaf_sha512sum_path = "${corp104_karaf::tmp_path}/karaf.sha512sum"
  $karaf_unpackage_path = "${corp104_karaf::tmp_path}/apache-karaf-${corp104_karaf::version}"

  # Java 
  include corp104_karaf::openjdk_java

  # Download karaf
  if $corp104_karaf::http_proxy {

    # set mvn behind proxy
    $proxy_ip_and_port = split($corp104_karaf::http_proxy, '//')[1]
    $proxy_ip = split($proxy_ip_and_port, ':')[0]
    $proxy_port = split($proxy_ip_and_port, ':')[1]
    file{"/root/.m2":
      ensure  =>  directory,
    }
    file { '/root/.m2/settings.xml':
      ensure  => 'present',
      content => template('corp104_karaf/settings.xml.erb'),
    }

    exec { 'download-karaf-sha512sum':
      provider => 'shell',
      command  => "curl -x ${corp104_karaf::http_proxy} ${karaf_sha512sum_url} > ${karaf_sha512sum_path}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "test -e ${karaf_sha512sum_path}",
    }

    exec { 'download-karaf':
      provider => 'shell',
      command  => "curl -x ${corp104_karaf::http_proxy} -o ${karaf_download_path} -O ${karaf_download_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "cd ${corp104_karaf::tmp_path} && sha512sum -c ${karaf_sha512sum_path}",
    }
  }
  else {
    exec { 'download-karaf-sha512sum':
      provider => 'shell',
      command  => "curl ${karaf_sha512sum_url} > ${karaf_sha512sum_path}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "test -e ${karaf_sha512sum_path}",
    }

    exec { 'download-karaf':
      provider => 'shell',
      command  => "curl -o ${karaf_download_path} -O ${karaf_download_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "cd ${corp104_karaf::tmp_path} && sha512sum -c ${karaf_sha512sum_path}",
    }
  }

  # Unpackage
  exec { 'unpackage karaf':
    provider    => 'shell',
    command     => "tar xvf ${karaf_download_path} -C ${corp104_karaf::tmp_path}",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    refreshonly => true,
    subscribe   => Exec['download-karaf'],
  }

  # Copy file
  file { 'karaf':
    ensure             => present,
    source             => $karaf_unpackage_path,
    path               => $corp104_karaf::install_path,
    recurse            => true,
    replace            => false,
    source_permissions => use,
  }
}
