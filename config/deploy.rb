set :stage, 'production'

set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'

set :application, 'vinsol_campus_hiring'
set :repo_url, 'git@github.com:chetna1726/vinsol_campus_hiring.git'
set :pty, true
set :scm, 'git'
set :deploy_via, :remote_cache
set :rails_env, 'production'

server '52.37.28.192',  user: 'vinsol', roles: %w(app web db)
server '52.36.138.123', user: 'vinsol', roles: %w(worker)

set :deploy_to, '/var/www/apps/vinsol_campus_hiring'
set :branch, ENV['BRANCH'] || 'deploy'

set :keep_releases, 5

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/thinking_sphinx.yml', 'config/application.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'public/system', 'tmp/pids')

set :keep_assets, 2

# SSHKit.config.command_map[:rake]  = "bundle exec rake"
# SSHKit.config.command_map[:rails] = "bundle exec rails"
