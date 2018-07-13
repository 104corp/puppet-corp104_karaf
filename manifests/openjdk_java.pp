class corp104_karaf::openjdk_java inherits corp104_karaf {
  $package_name = 'openjdk-8-jre'
  $java_home    = '/usr/lib/jvm/java-8-openjdk-amd64'

  $add_apt_package = [ 'python-software-properties', 'software-properties-common' ]
  package { $add_apt_package:
    ensure => present,
    notify => Exec['install-ppa'],
  }

  if $corp104_karaf::http_proxy {
    exec { 'install-ppa':
      path        => '/bin:/usr/sbin:/usr/bin:/sbin',
      environment => [
        "http_proxy=${corp104_karaf::http_proxy}",
      ],
      command     => "add-apt-repository -y ${corp104_karaf::ppa_openjdk} && apt-get update",
      user        => 'root',
      unless      => "/usr/bin/dpkg -l | grep ${package_name}",
      before      => Package[$package_name],
    }
  } else {
    exec { 'install-ppa':
      path    => '/bin:/usr/sbin:/usr/bin:/sbin',
      command => "add-apt-repository -y ${corp104_karaf::ppa_openjdk} && apt-get update",
      user    => 'root',
      unless  => "/usr/bin/dpkg -l | grep ${package_name}",
      before  => Package[$package_name],
    }
  }

  augeas { 'java-home-environment':
    lens    => 'Shellvars.lns',
    incl    => '/etc/environment',
    changes => "set JAVA_HOME ${java_home}",
  }

  package { $package_name:
    ensure => installed,
  }
}
