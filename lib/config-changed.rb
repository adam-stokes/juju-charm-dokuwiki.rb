require 'charmkit'

class ConfigChanged < Charmkit
  plugin :core
  plugin :hookenv

  def summon
    app_path = config 'app_path'
    hook_path = ENV['JUJU_CHARM_DIR']

    admin_user = config 'admin_user'
    admin_password = config 'admin_password'
    admin_name = config 'admin_name'
    admin_email = config 'admin_email'
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
    run "systemctl restart php7.0-fpm"
    run "systemctl restart nginx"
    status :active, "Ready"
  end
end
