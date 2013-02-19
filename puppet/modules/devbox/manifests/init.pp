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

    #include laravel
}
