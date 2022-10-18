# config valid for current version and patch releases of Capistrano
lock "3.16.0"

set :application, "g-camp"
set :repo_url, "git@gitlab.com:hyaminh2303/g-camp.git"

set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets tmp/pdfs vendor/bundle public/system public/uploads)


# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

#Bundler
set :bundle_binstubs, nil

#Rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all # default value
set :bundle_jobs, 1

# Passenger
set :passenger_restart_with_touch, true
set :passenger_restart_options, {}

# Whenever
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
