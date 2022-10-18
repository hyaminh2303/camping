FROM ruby:2.7.4

# Essentials install
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get update -y

# JS runtime install
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
# RUN apt-get update -y
# RUN apt-get install -y npm

# install Yarn
RUN npm install yarn -g

#install python2
RUN apt-get install -y python2

# Database client to connect to the database service
RUN apt-get install -y postgresql postgresql-contrib

# Sets zsh as the containers shell
RUN apt-get install -y zsh
RUN chsh -s $(which zsh)

# install chromedriver for testing
# RUN apt-get install -y chromedriver

# Create new user `dev` and disable
# password and gecos for later
# --gecos explained well here:
# https://askubuntu.com/a/1195288/635348
RUN adduser --disabled-password --gecos '' dev

# Install sudo
RUN apt-get update && \
      apt-get -y install sudo

#  Add new user dev to sudo group
RUN adduser dev sudo

# Ensure sudo group users are not
# asked for a password when using
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Base directory from now on
ENV DIR /var/www

RUN mkdir $DIR
WORKDIR $DIR
ADD . $DIR

# bundle config
ENV BUNDLE_GEMFILE=$DIR/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=$DIR/vendor/.bundle \
    GEM_HOME=$DIR/vendor/.bundle \
    BUNDLE_BIN=$DIR/vendor/.bundle/bin \
    BUNDLE_APP_CONFIG=$DIR/vendor/.bundle \
    PATH=$DIR/vendor/.bundle/bin:$PATH

RUN gem install bundler

# bundle the gems default
RUN cp Gemfile /
RUN cp Gemfile.lock /

# Forward default ssh key from host
RUN echo "eval \`ssh-agent -s\`" >> ~/.bashrc
RUN echo "ssh-add" >> ~/.bashrc
