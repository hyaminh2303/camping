# Start application in development mode with docker
### Make sure you already ```installed Docker``` and ```Docker Compose ```

# Setup first time (just once)
##Setup Development environment
```docker-compose build```

## Run into docker container for installing any service or package (if needed)
At rails root folder, run the command bellow
```./exec_docker.sh```

## By default this application will be running on port 3000. Please make sure that there is no application is running on port 3000

## Deploy production
```sudo apt-get install -y ruby-mini-magick```
Restart nginx after installed package above
