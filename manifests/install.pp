class corp104_karaf::install inherits corp104_karaf {

  $karaf_download_path = "${corp104_karaf::tmp_path}/${corp104_karaf::karaf_tar_filename}"
  $karaf_sha512sum_path = "${corp104_karaf::tmp_path}/karaf.sha512sum"
  $karaf_unpackage_path = "${corp104_karaf::tmp_path}/${corp104_karaf::karaf_unpackage_dir}"

  # Java 
  include corp104_karaf::openjdk_java

  # Setting maven behind proxy
  if $corp104_karaf::http_proxy {
    $proxy_ip_and_port = split($corp104_karaf::http_proxy, '//')[1]
    $proxy_ip = split($proxy_ip_and_port, ':')[0]
    $proxy_port = split($proxy_ip_and_port, ':')[1]

    file{ '/root/.m2':
      ensure  =>  directory,
    }

    file { '/root/.m2/settings.xml':
      ensure  => 'present',
      content => template('corp104_karaf/settings.xml.erb'),
    }
  }

  # Download karaf
  if $corp104_karaf::http_proxy and $corp104_karaf::download_karaf_through_proxt{
    exec { 'download-karaf-sha512sum':
      provider => 'shell',
      command  => "curl -x ${corp104_karaf::http_proxy} ${corp104_karaf::karaf_sha512sum_url} > ${karaf_sha512sum_path}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "test -e ${karaf_sha512sum_path}",
    }
    exec { 'download-karaf':
      provider    => 'shell',
      command     => "curl -x ${corp104_karaf::http_proxy} -o ${karaf_download_path} -O ${corp104_karaf::karaf_download_url}",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      subscribe   => Exec['download-karaf-sha512sum'],
      refreshonly => true,
    }
  }
  else {
    exec { 'download-karaf-sha512sum':
      provider => 'shell',
      command  => "curl ${corp104_karaf::karaf_sha512sum_url} > ${karaf_sha512sum_path}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "test -e ${karaf_sha512sum_path}",
    }

    exec { 'download-karaf':
      provider    => 'shell',
      command     => "curl -o ${karaf_download_path} -O ${corp104_karaf::karaf_download_url}",
      path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      subscribe   => Exec['download-karaf-sha512sum'],
      refreshonly => true,
    }
  }

  # Measure checksum
  exec { 'measure checksum':
    provider    => 'shell',
    command     => "cd ${corp104_karaf::tmp_path} && sha512sum -c ${karaf_sha512sum_path}",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    subscribe   => Exec['download-karaf'],
    refreshonly => true,
  }

  # Unpackage
  exec { 'unpackage karaf':
    provider    => 'shell',
    command     => "tar xvf ${karaf_download_path} -C ${corp104_karaf::tmp_path}",
    path        => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    refreshonly => true,
    subscribe   => Exec['measure checksum'],
  }

  # Copy file
  file { 'karaf':
    ensure             => present,
    source             => $karaf_unpackage_path,
    path               => $corp104_karaf::install_path,
    recurse            => true,
    replace            => false,
    source_permissions => use,
    subscribe          => Exec['unpackage karaf'],
  }
}
