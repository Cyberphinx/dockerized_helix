# Dockerized Helix

### Usage:
- For building the image: `sudo docker build -t <username>/helix .`
- For running as a binary: `sudo docker run -it --rm -v $(pwd):/code <username>/helix`
- For interactive shell: `docker run -it --rm -v $(pwd):/code --entrypoint /bin/ash <username>/helix`