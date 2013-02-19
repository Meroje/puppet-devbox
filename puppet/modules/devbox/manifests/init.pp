# Main module
class devbox ($hostname, $documentroot, $gitUser, $gitEmail) {
    # Set paths
    Exec {
        path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
    }

    include bootstrap

    # Insert MySQL server here
    # Or insert Postgres server, see #3

    include redis
    include postfix
    include ruby
    include php

    class { "apache":
        hostname => $hostname,
        documentroot => $documentroot
    }

    class { "git":
        gitUser => $gitUser,
        gitEmail => $gitEmail
    }

    include vim

    file { "/vagrant/$documentroot":
        ensure => "directory",
    }

    include composer

    # One day the following may be possible, until then we need to clone
    # composer::project { 'laravel':
    #     project_name => 'laravel/laravel',
    #     target_dir   => "/vagrant/$documentroot/laravel",
    #     keep_vcs     => true
    # }

    # Clone laravel
    exec { 'clone laravel':
        cwd     => "/vagrant/$documentroot",
        user    => "vagrant",
        command => "git clone --branch=develop http://github.com/laravel/laravel.git /vagrant/$documentroot/laravel",
        creates => "/vagrant/$documentroot/laravel",
        require => Package['git']
    }

    # Install laravel dependencies
    composer::exec { 'laravel-install':
        cmd => 'install',  # REQUIRED
        cwd => "/vagrant/$documentroot/laravel", # REQUIRED
        dev => true, # Install dev dependencies
    }
}
