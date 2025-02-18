# Pypi multi repository with private and pypi.org

Many companies needs to host pypi repositories for their own packages. Hosting can be configured with information in https://packaging.python.org/en/latest/guides/hosting-your-own-index/. Others solutions like JFrog Artifactory or Sonatype® Nexus can be used as well. After configuring a new pypi repository come the time to configuration of tools to use it which is the purpose of this post.

Serval tools can be used for interracting with the repository.

Here we use simple repository API as described in PEP 503.

Simple pypi repository accessed via web
For your private repo, to get either all the packages present in a repo or the files associated with a package :
```bash
curl --netrc https://my-pypi-repo-host/repository/my-pypi-hosted-repo/simple/
curl --netrc https://my-pypi-repo-host/repository/my-pypi-hosted-repo/simple/<"package_name">
```
To get all the package files of a repository with wget (login/passwd in .netrc) :

```bash
wget --mirror -e robots=off https://my-pypi-repo-host/repository/my-pypi-hosted-repo/simple/
```

Here we use a ~/.netrc file with 0600 rights for login/password :

```text
machine my-pypi-repo-host
    login my-user
    password my-pass
Twine for uploading
# content of ~/.pypirc file
[distutils]
index-servers = my-pypi-repo-name
[my-pypi-repo-name]
repository: https://my-pypi-repo-host/repository/my-pypi-hosted-repo/
username: my-user
password: my-pass
```

After that, give the root certificate to twine either by environement variable or with the command line :

```bash
# Serval environement variable can be use, here we use one just for twine
# export TWINE_CERT=/etc/ssl/certs/ca-certificates.crt
# Without environement variable set the root certificate is given directly in the command line
twine upload -r my-pypi-repo-name --cert /usr/local/share/ca-certificates/my-root-cert.crt dist/*
```

PIP for downloading packages
Here we configure pip to use both private repo and pypi.org :

```text
# ~/.config/pip/pip.conf file for direct access
[global]
index-url = https://my-pypi-repo-host/repository/my-pypi-hosted-repo/simple
extra-index-url= https://pypi.org/simple
cert = /etc/ssl/certs/ca-certificates.crt
# Note the /etc/ssl/certs/ca-certificates.crt with both root certificate for both my-pypi-repo-host and pypi.org
Poetry for downloading packages
```

Here we configure poetry to use both private repo and pypi.org :

```bash
poetry source add --priority=primary my-pypi-repo-name https://my-pypi-repo-host/repository/my-pypi-hosted-repo/simple/
poetry config certificates.my-pypi-repo-name.cert /usr/local/share/ca-certificates/my-root-cert.crt
poetry config http-basic.my-pypi-repo-name my-user my-pass
poetry source add --priority=supplemental pypi
```

After that check pyproject.toml file for sources and ~/.config/pypoetry/auth.toml for user/pass and cert.

Note that poetry support publish command but only with Legacy Upload API and I didn't tested it.