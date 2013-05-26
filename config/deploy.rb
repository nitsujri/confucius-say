require "bundler/capistrano"

set :application, "confucius-say"
set :repository,  "git@github.com:nitsujri/confucius-say.git"

role :app, "ec2-54-214-168-144.us-west-2.compute.amazonaws.com"
role :web, "ec2-54-214-168-144.us-west-2.compute.amazonaws.com"
role :db, "ec2-54-214-168-144.us-west-2.compute.amazonaws.com"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "ubuntu"
set :use_sudo, false
set :deploy_via, :remote_cache
set :keep_releases, 5

set :deploy_to, "/data/#{application}"

set :bundle_flags, "--deployment --quiet --binstubs"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

# answer = Capistrano::CLI.ui.ask "Are you sure you want to deploy *PRODUCTION*? [yes/NO]: "
# unless answer == 'yes'
#   raise CommandError.new("Decided NOT to deploy to Production.")
# end

before 'deploy:update_code', "deploy:add_host_keys"
before 'deploy:assets:precompile', 'deploy:cp_database_yml'
after 'deploy:update_code', 'deploy:cleanup'

namespace :deploy do
  task :add_host_keys do
    run "sudo bash -c 'ssh-keyscan -t rsa github.com > /etc/ssh/ssh_known_hosts'"
  end

  desc "Replacing the database.yml"
  task :cp_database_yml do
    old_path = File.join(release_path, "config", "database.yml.production")
    new_path = File.join(release_path, "config", "database.yml")
    run "cp #{old_path} #{new_path}"
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end