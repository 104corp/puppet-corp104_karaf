class corp104_karaf::openjdk_java inherits corp104_karaf {
  $package_jre = 'openjdk-8-jre'
  $package_jdk = 'openjdk-8-jdk'
  $java_home    = '/usr/lib/jvm/java-8-openjdk-amd64'

  $add_apt_packages = [ 'python-software-properties', 'software-properties-common' ]
  $add_apt_packages.each | String $add_apt_package| {
    if ! defined(Package[$add_apt_package]){
      package { $add_apt_package:
        ensure => present,
        notify => Exec['install-ppa'],
      }
    }
  }

  if ! defined(Exec['install-ppa']) {
    if $corp104_karaf::http_proxy {
      exec { 'install-ppa':
        path        => '/bin:/usr/sbin:/usr/bin:/sbin',
        environment => [
          "http_proxy=${corp104_karaf::http_proxy}",
        ],
        command     => "add-apt-repository -y ${corp104_karaf::ppa_openjdk} && apt-get update",
        user        => 'root',
        unless      => "/usr/bin/dpkg -l | grep ${package_jre}",
        before      => Package[$package_jre],
      }
    } else {
      exec { 'install-ppa':
        path    => '/bin:/usr/sbin:/usr/bin:/sbin',
        command => "add-apt-repository -y ${corp104_karaf::ppa_openjdk} && apt-get update",
        user    => 'root',
        unless  => "/usr/bin/dpkg -l | grep ${package_jre}",
        before  => Package[$package_jre],
      }
    }
  }

  augeas { 'java-home-environment':
    lens    => 'Shellvars.lns',
    incl    => '/etc/environment',
    changes => "set JAVA_HOME ${java_home}",
  }

  package { $package_jre:
    ensure => installed,
  }

  if $corp104_karaf::jdk_enable {
    package { $package_jdk:
      ensure => present,
    }
  } else {
    package { $package_jdk:
      ensure => purged,
    }
    package { "${package_jdk}-headless":
      ensure => purged,
    }
  }
}
