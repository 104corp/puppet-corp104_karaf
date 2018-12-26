# Class: corp104_karaf
# ===========================
#
# Full description of class corp104_karaf here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'corp104_karaf':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class corp104_karaf (
  Optional[String] $http_proxy,
  Boolean $jdk_enable,
  String $version,
  String $tmp_path,
  String $install_path,
  String $ppa_openjdk,
  String $karaf_download_url,
  String $karaf_sha512sum_url,
  String $karaf_tar_filename,
  String $karaf_unpackage_dir,
  Boolean $download_karaf_through_proxt,
){

  contain corp104_karaf::install
  contain corp104_karaf::config
  contain corp104_karaf::service

  Class['::corp104_karaf::install']
  -> Class['::corp104_karaf::config']
  ~> Class['::corp104_karaf::service']
}
