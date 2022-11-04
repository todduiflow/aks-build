
#!/bin/sh
docker context use default
docker load --input davidsauthtestcg8zajs7-main.image
docker compose -f docker-compose.local.yml up -d
