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
after 'deploy:update_code', 'bundler:bundle_new_release'

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


#the following from http://gist.github.com/244420
namespace :bundler do
  task :install, :roles => :app, :except => { :no_release => true }  do
    run("gem install bundler --source=http://gemcutter.org")
  end
 
  task :symlink_vendor, :roles => :app, :except => { :no_release => true } do
    shared_gems = File.join(shared_path, 'vendor/bundled_gems/ruby/1.8')
    release_gems = "#{release_path}/vendor/bundled_gems/ruby/1.8"
    %w(gems specifications).each do |sub_dir|
      shared_sub_dir = File.join(shared_gems, sub_dir)
      run("mkdir -p #{shared_sub_dir} && mkdir -p #{release_gems} && ln -s #{shared_sub_dir} #{release_gems}/#{sub_dir}")
    end
  end
 
  task :bundle_new_release, :roles => :app, :except => { :no_release => true }  do
    bundler.symlink_vendor
    run("cd #{release_path} && gem bundle --only production --cached")
  end
end
 
