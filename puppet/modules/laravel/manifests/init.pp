class laravel {
    composer::project { 'laravel':
        project_name => 'laravel/laravel',
        target_dir   => "/vagrant/$devbox::documentroot/laravel",
        keep_vcs     => true,
        dev          => true
    } -> exec { "laravel.htaccess.documentroot":
        command => "sed -i 's/index.php/%{DOCUMENT_ROOT}\/index.php/g' /vagrant/$devbox::documentroot/laravel/public/.htaccess",
        onlyif => "grep \"RewriteRule \^ index.php\" /vagrant/$devbox::documentroot/laravel/public/.htaccess"
    }
}