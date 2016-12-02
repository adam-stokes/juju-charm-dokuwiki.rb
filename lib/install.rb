require 'charmkit'

class Install < Charmkit
  plugin :core

  def summon
    log "Installing required packages"
    package [
        'nginx-full', 'php-fpm',      'php-cgi',      'php-curl', 'php-gd', 'php-json',
        'php-mcrypt', 'php-readline', 'php-mbstring', 'php-xml'
    ], :update_cache
    app_path = config 'app_path'
    hook_path = ENV['JUJU_CHARM_DIR']

    mkdir_p app_path unless is_dir? app_path

    run "tar xf #{resource('stable-release')} -C #{app_path} --strip-components=1"
    rm "#{app_path}/conf/install.php" if is_file? "#{app_path}/conf/install.php"
    cp "#{hook_path}/templates/acl.auth.php", "#{app_path}/conf/acl.auth.php"
    cp "#{hook_path}/templates/local.php", "#{app_path}/conf/local.php"
    cp "#{hook_path}/templates/plugins.local.php", "#{app_path}/conf/plugin.local.php"

    version = cat "#{app_path}/VERSION"
    run "application-version-set '#{version}'"
    status :active, "Dokuwiki Install finished."
  end
end
