class corp104_karaf::install inherits corp104_karaf {

  # if $manage_java {
    
  # }
  # else {
    
  # }

  $karaf_downlod_url = "http://apache.stu.edu.tw/karaf/${corp104_karaf::version}/apache-karaf-${corp104_karaf::version}-src.tar.gz
"

  if $corp104_karaf::http_proxy {
    exec { 'download-karaf':
      provider => 'shell',
      command  => "curl -x ${corp104_karaf::http_proxy} -o ${corp104_karaf::install_tmp} -O ${karaf_downlod_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    }
  }
  else {
    exec { 'download-karaf':
      provider => 'shell',
      command  => "curl -o ${corp104_karaf::install_tmp} -O ${karaf_downlod_url}",
      path     => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
    }
  }
}
