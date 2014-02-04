Devbox Puppet Config
====================

This is my personal puppet configuration which I use with vagrant to setup my development box.

It installs the following:
* PHP 5.4.6
* Apache 2.2.22
* Ruby 1.9.3p194
* Redis 2.6.10
* Git
* PHPUnit 3.7.14
* Vim

It has been tested with a Ubuntu precise64 box.

Requirements
------------
* Puppet
* Vagrant

Usage
-----

Create a Vagrantfile in the root of your project with the following contents:

```
Vagrant::Config.run do |config|
    config.vm.box = "precise64"
    config.vm.network :hostonly, "33.33.33.10"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file  = "site.pp"
        puppet.options = "--verbose"
    end
end
```

Create a puppet directory that will hold your manifests.

```
$ mkdir -p puppet/manifests
```

Now create a the ```puppet/manifests/site.pp``` file with the following:
```
class { "devbox":
    hostname => "some-dev-box", # Make sure this maps to the address above
    documentroot => "web", # Apache documentroot eg: www, web, public_html etc
    gitUser => "Your full name",
    gitEmail => "Your email address"
}
```

Run vagrant up to start downloading (if the box hasn't been downloaded yet) and initializing your machine:
```
vagrant up
```

Now you can run ```vagrant ssh``` to login to your box.

The ```web``` directory in your project dir will be served by Apache.

To access phpMyAdmin you can just enter the IP address of the machine in your browser or any other hostname than provided above that maps to that IP address.

