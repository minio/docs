# Setup Minio using Puppet [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Puppet][puppet] is an Open Source configuration management system, allowing for
automated system provisioning.

In this recipe you will learn how to deploy Minio using Puppet as standalone
installation.

## 1. Prerequsites

This cookbook assumes that you have a working Puppet setup (at least an agent for
running Puppet recipes).

## 2. Installation

Install the required Puppet modules:

*   [puppet-minio][puppet-minio]
*   dependency [Remote_File][puppet-remote_file]
*   dependency [stdlib][puppetlabs-stdlib]

If you only use Puppet agent, you can run

```
puppet module install --modulepath=modules kogitoapp-minio --version 1.0.1
puppet module install --modulepath=modules lwf-remote_file --version 1.1.3
puppet module install --modulepath=modules puppetlabs-stdlib --version 4.16.0
```

If you use a Puppet control repository with a `Puppetfile` you an add it there
instead:

```
mod 'kogitoapp-minio', '1.0.1'
mod 'lwf-remote_file', '1.1.3'
mod 'puppetlabs-stdlib', '4.16.0'
```
## 3. Configuration

The following snippet will produce a local installation available on port `9000`
which is the default behavior of the module.

```puppet
class { 'minio':
    version => 'RELEASE.2017-05-05T01-14-51Z',
    checksum => '59cd3fb52292712bd374a215613d6588122d93ab19d812b8393786172b51d556',
    configuration_directory => '/etc/minio',
    installation_directory => '/opt/minio',
    storage_root => '/var/minio',
    log_directory => '/var/log/minio',
    listen_ip => '127.0.0.1',
    listen_port => '9000',
    configuration => {
        'credential' => {
          'accessKey' => 'ADMIN',
          'secretKey' => 'PASSWORD',
        },
        'region' => 'us-east-1',
        'browser' => 'on',
    },
}
```

## 4. Recipe details

*   The Puppet module downloads a platform specific Minio release from the
    archives on <https://dl.minio.io/server/minio/release/> e.g. for 64bit
    Linux we use <https://dl.minio.io/server/minio/release/linux-amd64/archive/>
*   downloaded files will be checked against the SHA256 sums available for each
    release.
*   you can pass in _any_ configuration value to `minio::configuration` in hash
    form that is documented on <https://docs.minio.io/docs/minio-server-configuration-guide>
    to override defaults, e.g. setting different credentials or logging options
    for `production` and `development` environments.

## 5. Getting support

Feel free to visit the [module repository][puppet-minio] and raise an issue if
you need help or have suggestions for improvements.

[puppet]: https://puppet.com
[puppet-minio]: https://github.com/kogitoapp/puppet-minio
[puppet-remote_file]: https://github.com/lwf/puppet-remote_file
[puppetlabs-stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib
