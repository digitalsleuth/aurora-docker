# aurora-docker
Docker for Aurora Incident Response

- Customize the docker-compose.yaml to your liking (mount points, SHM size, etc)
- `sudo docker-compose up -d` in the directory with the compose file
- `ssh -X aurora@0.0.0.0 -p 33` or whatever IP/PORT you choose in the compose file, password is `aurora`. The port is 33 to avoid collision with any possible SSH server in play on the current system, and the 0.0.0.0 is default. You can customize the network as you wish!
- Run `aurora` from the command prompt.
