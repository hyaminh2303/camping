server_str = '13.115.31.37'
user_str = 'ubuntu'

role :app, "#{user_str}@#{server_str}"
role :web, "#{user_str}@#{server_str}"
role :db,  "#{user_str}@#{server_str}"

server server_str, user: user_str, roles: %w(web app)

set :branch, 'develop'
set :rails_env, 'production'
set :linked_files, %w(application.yml database.yml credentials/production.key).map { |str| "config/#{str}" }

set :deploy_to, '~/g_camp_production'
set :passenger_restart_command,
    "touch /home/#{user_str}/g_camp_production/current/tmp/restart.txt"
