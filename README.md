# puppet module corp104_karaf_container
[![Build Status](https://travis-ci.org/104corp/puppet-corp104_karaf_container.svg?branch=master)](https://travis-ci.org/104corp/puppet-corp104_karaf_container)


#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with corp104_karaf_container](#setup)
    * [Beginning with corp104_karaf_container](#beginning-with-corp104_karaf_container)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The corp104_karaf_container module installs, configures, and manages the corp104_karaf_container service across a range of operating systems and distributions.

## Setup

### Beginning with corp104_karaf_container

`include '::corp104_karaf_container'` is enough to get you up and running.

## Usage

All parameters for the ntp module are contained within the main `::corp104_karaf_container` class, so for any function of the module, set the options you want. See the common usages below for examples.

### Install and enable corp104_karaf_container

```puppet
include '::corp104_karaf_container'
```


## Reference

### Classes

#### Public classes

* corp104_karaf_container: Main class, includes all other classes.

#### Private classes

* corp104_karaf_container::install Handles the packages.
* corp104_karaf_container::config Handles the config.
* corp104_karaf_container::service Handles the services.

## Limitations

This module cannot guarantee installation of corp104_karaf_container versions that are not available on  platform repositories.

This module is officially [supported](https://forge.puppetlabs.com/supported) for the following Java versions and platforms:

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. Please follow our guidelines when contributing changes.

For more information, see our [module contribution guide.](https://docs.puppetlabs.com/forge/contributing.html)

### Contributors

To see who's already involved, see the [list of contributors.](https://github.com/puppetlabs/puppetlabs-ntp/graphs/contributors)
