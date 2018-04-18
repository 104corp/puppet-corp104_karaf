class corp104_karaf_container::install inherits corp104_karaf_container {

  if $manage_java {
    
  }
  else {
    
  }

  $karaf_container_downlod_url = "http://www.apache.org/dyn/closer.lua/karaf_container/${corp104_karaf_container::version}/apache-karaf_container-${corp104_karaf_container::version}-src.tar.gz
"

  if $corp104_karaf_container::http_proxy {
    exec { 'download-karaf_container':
      provider => 'shell',
      command  => "curl -x ${corp104_karaf_container::http_proxy} -o ${corp104_karaf_container::install_tmp} -O ${karaf_container_downlod_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    }
  }
  else {
    exec { 'download-karaf_container':
      provider => 'shell',
      command  => "curl -o ${corp104_karaf_container::install_tmp} -O ${karaf_container_downlod_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    }
  }
}
