server_str = 'gcamp.webmtechnology.com'
user_str = 'ubuntu'

role :app, "#{user_str}@#{server_str}"
role :web, "#{user_str}@#{server_str}"
role :db,  "#{user_str}@#{server_str}"

server server_str, user: user_str, roles: %w(web app)

set :branch, 'qa'
set :rails_env, 'qa'
set :linked_files, %w(application.yml database.yml credentials/qa.key).map { |str| "config/#{str}" }

set :deploy_to, '~/g_camp_qa'
set :passenger_restart_command,
    "touch /home/#{user_str}/g_camp_qa/current/tmp/restart.txt"
