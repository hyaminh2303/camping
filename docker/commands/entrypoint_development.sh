# create database.yml
su dev

if ! [ -f ./config/database.yml ]; then
  cp docker/config/database.yml ./config/database.yml
fi

echo '***************************************************'
echo 'waiting for yarn installing (will take a while) ...'
echo '***************************************************'
yarn install --check-files

# bundle check and install
bundle install

# removing old rails server PIDs
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# run migrations
echo '***************************************************'
echo 'checking database migration ...'
echo '***************************************************'
rails db:migrate

# Add seed data
echo '***************************************************'
echo 'Adding seed data ...'
echo '***************************************************'
rails db:seed

# start rails server
# rails s -b 0.0.0.0
