# docker-dovecot

Dovecot IMAP server with fetchmail


## Description

* see [DEC](https://github.com/optb/docker-email-collector)

## Modifications

I needed a image for ARM. So I had to do a few changes
- changed base image to debian-12
- use dovecot packages from debian repo
- add redis container; rspamd depends on it, otherwise not spam/ham learn is possible

## Dockerhub

* [Docker image](https://hub.docker.com/repository/docker/juharov/dovecot-email-collector/general)

## License

This project is licensed under the Attribution-NonCommercial-ShareAlike 4.0 International License - see the [LICENSE.md](LICENSE.md) file for details

