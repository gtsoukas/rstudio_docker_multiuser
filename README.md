# Dockerized RStudio for Enterprises

This tutorial attempts to bring RStudio on Docker as close as possible to enterprise requirements. In particular, it features:
* Multi-user RStudio;
* Persistent storage of user's home folders;
* Working behind a proxy server.

## Multiple users
### Limitations
* Admins have to maintain a secret file with username and passwords.
* Users cannot change their passwords.

Create secret user credentials file:
```
mkdir secrets
touch secrets/accounts
chmod 600 secrets/accounts
echo "1001:user1:passwd1" >> secrets/accounts
echo "1002:user2:passwd2" >> secrets/accounts
echo "1003:user3:passwd3" >> secrets/accounts
```

Build container image:
```
docker build \
  --tag rstudio_multiuser \
  --rm \
  .
```

Run container:
```
docker run \
  -t \
  -i \
  -p 8899:8787 \
  --name rstudio_${USER} \
  --rm \
  -v ${PWD}/secrets:/secrets \
  -e PASSWORD="secret1" \
  rstudio_multiuser:latest
```

## Adding persistent storage
Containers are ephemeral, so it is highly recommended to give users the accustomed behavior of having a persistent storage.

Create a docker volume:
```
docker volume create rstudio_volume_${USER}
```

Run container:
```
docker run \
  -t \
  -i \
  -p 8899:8787 \
  --name rstudio_${USER} \
  --rm \
  -v ${PWD}/secrets:/secrets \
  -e PASSWORD="secret1" \
  -v rstudio_volume_${USER}:/home \
  rstudio_multiuser:latest
```

## Adding HTTP(S) proxy servers
Substitute or remove below certificate and proxy related variables and then run container:
```
docker run \
  -t \
  -i \
  -p 8899:8787 \
  --name rstudio_${USER} \
  --rm \
  -v ${PWD}/secrets:/secrets \
  -e PASSWORD="secret1" \
  -v rstudio_volume_${USER}:/home \
  -e CERT_URL="http://webproxy.example.org/sslproxy.crt" \
  -e http_proxy="http://webproxy.example.org:9099" \
  -e https_proxy="http://webproxy.example.org:9099" \
  rstudio_multiuser:latest
```

Users must export proxy variable from within RStudio Terminal:
```
export http_proxy="http://webproxy.example.org:9099"
export https_proxy="http://webproxy.example.org:9099"
```
