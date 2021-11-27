# docker-lamp-devel (pQn)
This is the pasquino flavored ubuntu based Dockerfile for php/pasquino apps development,
Its.'s based on [https://github.com/marcostrotti/docker-lamp-devel]
## Usage
### Build your image
ej: 
```bash
docker build -t asivas/liclinica:deMartino-dev -t asivas/liclinica:deMartino-latest .
```
poné la pava para el mate....

### Use your image runing a container
```bash
docker run -i -t -P --name myapp -v /home/me/workspace/myapp/:/var/www/html/ asivas/liclinica:deMartino-latest

```
Is important to run interactive first time, because pasquino installs on first run and it has 4 stages that require interaction

```
-P     map all exported ports
-i     (interctavice) Keep STDIN open even if not attached
-t     Allocate a pseudo-TTY
-v     Bind mount a volume
```

### Start using your container
With the run command you sould be able to use the contaier until you stop it,
whenever you need to use it again you shuld start it with docker start
```bash
docker start -ti myapp
``` 

## Environment Variables
The following environment variables are used on build to parametrize the image
###### New Relic (https://newrelic.com/)
This environment may be used only on build, there are applied before the apt install of newrelic package
`newrelic_application_name`: the appname for new relic monitor

`newrelic_licence_key`: the newrelic licence key for this app

###### PHP: 
This environment may be used on run, the run script modifies php.ini file 
`PHP_UPLOAD_MAX_FILESIZE` (default: 20M)

`PHP_POST_MAX_SIZE` (default: 20M)

`PHP_MEMORY_LIMT` (default: 2048M)

`PHP_ERROR_REPORTING` (default: "E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE")

###### CUPS client config
This environment variables are used both in build and run (used in /configure-scripts.sh)

`CUPS_SERVER` default: "192.168.82.14:631"

`CUPS_USER` default: "lucas"
