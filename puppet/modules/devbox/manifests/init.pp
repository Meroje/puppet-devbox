# Main module
class devbox ($hostname, $documentroot, $gitUser, $gitEmail) {
    # Set paths
    Exec {
        path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
    }

    include bootstrap
    class { 'percona': server => true, }
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
    include svn

    include zsh
    include vim

    include xhprof

    include composer

    composer::project { 'laravel':
        project_name => 'laravel/laravel',
        target_dir   => '/vagrant/web/laravel',
        keep_vcs     => true
    }
}
