# Intorduciton
This project takes all of its inspirations from this [link](http://pawamoy.github.io/2018/02/01/docker-compose-django-postgres-nginx.html). I had to write the project myself, and get my hands dirty. I would advice you do follow alone the setps yourself, to learn each setp. 
# How to use docker
To create a docker iamges we use the base `Dockerfile` as the main source. Additional resource will be added with the inclusion of the docker-compose file. The main `Dockerfile` provides us with the base on the container. 

## Creating the docker image from the `Dockerfile`
`docker build . -t app`
Where `-t` is a flag to tag your image

## Running a container from your new image
`docker run -p 8000:8000 --name django_app app`
`-p` is your mapping the ports from your container to your current envrionment. The left handside is your computer ports, and the right handside is your docker conatiner ports. This standard if followed across docker.

## Gunicorn
Since we are using the Gunicorn server and the not the base server. We have the following 2 commands working with gunicorn in django.

`gunicorn --bind :8000 app.wsgi:application`
This command needs to be run in the main django project where the `manage.py` file exsists.
---
`gunicorn --chdir app --bind :8000 app.wsgi.application`
This command is run from the root of the project, that is why we change directory to the django project.
---

# How to use Docker-Compose
To use more then 1 service in docker, you need to create a `docker-compose.yml` file. This files has all the configurations. For this current project will use `nginx` for routing our traffic. 
The key idea in the docker file are
1. Volume mounting
2. Network bridging

For us to achive this, we set the nginx setting th config folder, and the yml file, we use volume, for the app to be sync better the container and local dev environment.

Networking bridging allows us to use the multiple containers for the nginx if need, and the same bridging idea would be applicable when we link out databases.

# running command on django 
`docker-compose run djangoapp app/manage.py` <- base of the django command

`docker-compose run djangoapp app/manage.py createsuperuser` <- To create super user

`docker-compose run djangoapp app/manage.py startapp app_name` <- To create django app

`docker-compose run djangoapp app/manage.py collectstatic --no-input` <- static file generation for django