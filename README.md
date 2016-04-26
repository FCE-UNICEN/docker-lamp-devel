# docker-lamp-devel (pQn)
This is the pasquino flavored ubuntu based Dockerfile for php/pasquino apps development,
Its.'s based on [https://github.com/marcostrotti/docker-lamp-devel]
## Usage
### Build your image
ej: 
```bash
docker build -t asivas/pqn:1.0 -t asivas/pqn:latest .
```
poné la pava para el mate....

### Use your image runing a container
docker run -i -t -P --name myapp -v /home/me/workspace/myapp/:/var/www/html/ asivas/pqn
-P map all exported ports
-i 

### Start using your container
With the run command you sould be able to use the contaier until you stop it,
whenever you need to use it again you shuld start it with docker start
```bash
docker start -ti
``` 
## TODO

* add alias in apache configuration for phpmyadmin
* enable login without password  for phpmyadmin
