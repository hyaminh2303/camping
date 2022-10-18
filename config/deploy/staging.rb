server_str = 'demo.gcamp.jp'
user_str = 'ubuntu'

role :app, "#{user_str}@#{server_str}"
role :web, "#{user_str}@#{server_str}"
role :db,  "#{user_str}@#{server_str}"

server server_str, user: user_str, roles: %w(web app)

set :branch, 'staging'
set :rails_env, 'staging'
set :linked_files, %w(application.yml database.yml credentials/staging.key).map { |str| "config/#{str}" }

set :deploy_to, '~/g_camp_staging'
set :passenger_restart_command,
    "touch /home/#{user_str}/g_camp_staging/current/tmp/restart.txt"
