set :application, "follow-that-bird"
set :repository,  "git://github.com/jbr/follow-that-bird.git"

default_run_options[:pty] = true

set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, 'deploy'
set :use_sudo, false
set :deploy_to, "/var/www/apps/#{application}"

role :app, "jacobrothstein.com"
role :web, "jacobrothstein.com"
role :db,  "jacobrothstein.com", :primary => true


after 'deploy:symlink', 'deploy:copy_config_files'

namespace :deploy do
  task :copy_config_files do
    run "cp #{shared_path}/config/* #{current_path}/config"
  end

  task :restart do
    sudo "monit -g ftb restart all"
  end
  
  task :start do
    sudo "monit -g ftb start all"
  end
  
  task :stop do
    sudo "monit -g ftb stop all"
  end
end
