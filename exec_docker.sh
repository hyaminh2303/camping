docker-compose up -d web && docker-compose exec web cp -r /root/.ssh/ /home/dev/ && docker-compose exec web chmod -R 777 /home/dev/.ssh/ && docker-compose exec -u dev web bash