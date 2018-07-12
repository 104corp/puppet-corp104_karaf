class corp104_karaf::install inherits corp104_karaf {

  $karaf_download_url = "http://ftp.twaren.net/Unix/Web/apache/karaf/${corp104_karaf::version}/apache-karaf-${corp104_karaf::version}.tar.gz"
  $karaf_sha512sum_url = "https://www.apache.org/dist/karaf/${corp104_karaf::version}/apache-karaf-${corp104_karaf::version}.tar.gz.sha512"
  $karaf_download_path = "${corp104_karaf::tmp_path}/apache-karaf-${corp104_karaf::version}.tar.gz"
  $karaf_sha512sum_path = "${corp104_karaf::tmp_path}/karaf.sha512sum"
  $karaf_unpackage_path = "${corp104_karaf::tmp_path}/apache-karaf-${corp104_karaf::version}"

  # Java 
  include corp104_karaf::openjdk_java

  # Download sha512sum first
  exec { 'download-karaf-sha512sum':
    provider => 'shell',
    command  => "curl ${karaf_sha512sum_url} > ${karaf_sha512sum_path}",
    path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
<<<<<<< HEAD
    unless   => 'test -e ${karaf_sha512sum_path}',
=======
    unless   => "test -e ${karaf_sha512sum_path}",
>>>>>>> a13a59da623bb575393f06c5bd2edb60381829ef
  }

  # Download karaf
  if $corp104_karaf::http_proxy {
    exec { 'download-karaf':
      provider => 'shell',
      command  => "curl -x ${corp104_karaf::http_proxy} -o ${karaf_download_path} -O ${karaf_download_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
      unless   => "cd ${corp104_karaf::tmp_path} && sha512sum -c ${karaf_sha512sum_path}",
    }
  }
  else {
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
    source             => "${karaf_unpackage_path}",
    path               => "${corp104_karaf::install_path}",
    recurse            => true,
    replace            => false,
    source_permissions => use,
  }
}
