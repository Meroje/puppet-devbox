# One day the following may be possible, until then we need to clone
# composer::project { 'laravel':
#     project_name => 'laravel/laravel',
#     target_dir   => "/vagrant/$documentroot/laravel",
#     keep_vcs     => true
# }

# Clone laravel
exec { 'laravel.clone':
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

# Fix htaccess for vhost_alias
exec { "laravel.htaccess.documentroot":
    command => "sed -i 's/index.php/%{DOCUMENT_ROOT}\/index.php/g' /vagrant/$documentroot/laravel/public/.htaccess",
    onlyif => "grep \"RewriteRule \^ index.php\" /vagrant/$documentroot/laravel/public/.htaccess",
    require => Exec['laravel.clone']
}

# Chmod
file { "/vagrant/$documentroot/laravel/app/storage":
    ensure  => "directory",
    mode    => "0777",
    recurse => true,
    require => Exec['laravel.clone']
}