namespace :dokuwiki do

  desc "Install required apt packages"
  task :install_deps do
    pkgs = [
      'nginx-full', 'php-fpm',      'php-cgi',      'php-curl', 'php-gd', 'php-json',
      'php-mcrypt', 'php-readline', 'php-mbstring', 'php-xml'
    ]
    `apt-get update`
    `apt-get install -qyf #{pkgs.join(' ')}`
  end

  desc "Install Dokuwiki"
  task :install => [:install_deps] do
    app_path = `config-get app_path`
    resource_path = `resource-get stable-release`
    hook_path = ENV['JUJU_CHARM_DIR']

    mkdir_p app_path unless Dir.exists? app_path

    `tar xf #{resource_path} -C #{app_path} --strip-components=1`
    rm "#{app_path}/conf/install.php" if File.exists? "#{app_path}/conf/install.php"
    cp "#{hook_path}/templates/acl.auth.php", "#{app_path}/conf/acl.auth.php"
    cp "#{hook_path}/templates/local.php", "#{app_path}/conf/local.php"
    cp "#{hook_path}/templates/plugins.local.php", "#{app_path}/conf/plugin.local.php"

    version = File.read "#{app_path}/VERSION"
    `application-version-set '#{version}'`
    `status-set active Dokuwiki Install finished.`
  end

  desc "Configure Dokuwiki"
  task :configure do
    app_path = `config-get app_path`
    hook_path = ENV['JUJU_CHARM_DIR']

    admin_user = `config-get #{admin_user}`
    admin_password = `config-get admin_password`
    admin_name = `config-get admin_name`
    admin_email = `config-get admin_email`
    template "#{hook_path}/templates/users.auth.php",
             "#{app_path}/conf/users.auth.php",
             admin_user: admin_user,
             admin_password: admin_password,
             admin_name: admin_name,
             admin_email: admin_email

    template "#{hook_path}/templates/vhost.conf",
             "/etc/nginx/sites-enabled/default",
             public_address: unit('public-address'),
             app_path: app_path

    chown_R 'www-data', 'www-data', app_path

    # TODO: service :restart, "nginx"
    # TODO: service :restart, "php7.0-fpm"
    `systemctl restart php7.0-fpm`
    `systemctl restart nginx`
    `status-set active Ready`
  end
end
