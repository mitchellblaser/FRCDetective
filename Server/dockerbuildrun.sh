docker build -t detective-server .
docker run --rm --name detective-server -p 5584:5584 detective-server