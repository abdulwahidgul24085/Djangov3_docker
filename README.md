# Intorduciton
This project takes all of its inspirations from this [link](http://pawamoy.github.io/2018/02/01/docker-compose-django-postgres-nginx.html). I had to write the project myself, and get my hands dirty. I would advice you do follow alone the setps yourself, to learn each setp. 

## Using the Repo
This repo helps you achive the following tools integration and start-up using docker
1. Django
2. Nginx
3. Postgres SQL

All of these tools are linked with a concept called [bridging in docker](https://docs.docker.com/network/bridge/). What this let's you do is, to have multiple containers for database an ngix running by adding them to the docker-compose file. Follow along the example of the default database, and nigx server to have multiple container running.

## Running the Repo
Docker need's to be installed. You can use the following common to build your docker-compose images and containers
`docker-compose up --build` <-- Run and Build docker-compose
`docker-compose stop` <-- To stop the containers running
`docker-compose ps` <-- To see all the containers running for this project
`docker-compose down` <-- To delete all the tools build with the docker-compose

The database, static, and media configuration has been set in the base docker-compose. Also, the database, media and static files are are mounted outside of the container, so that you don't lose any data if you remove the containers, or the images. This is for persistance sake. 

# Docker chaning the setting in docker-compose file
## Database setting
In the `settings.py` contains your database name, username and password. That is imported from `config/db/django_databae1_env` in the docker-compose file, and as set in the Django project. You need to make sure you change the `env` and `settings.py database` values to have a different settings

## Runing Django commands
You can use the following code to run Django commands.
``docker-compose run --rm djangoapp /bin/bash -c "cd app; ./manage.py "` <-- djangoapp is the same name that is set in the `docker-compose.yml` file under services. This need to be consistance since that is the name of your applicaiton. You can change that, but make sure that change is reflected when you are running this command. `--rm` Flag, this is what docker has to say about it.
> Remove container after run. Ignored in detached mode.

### Django Create Super User
`docker-compose run --rm djangoapp app/manage.py createsuperuser` <-- create admin user.

### Django Create Apps
`docker-compose run --rm djangoapp /bin/bash -c "cd app; ./manage.py startapp django_app_name"` <-- We need to change into the app folder in the container. and run the command.

### Django Make Migrations
Make sure when you start an app, to always included it in the `settings.py`, or else the migrations won't work.
`docker-compose run --rm djangoapp app/manage.py showmigrations` <-- To show the migrations
`docker-compose run --rm djangoapp app/manage.py makemigrations` <-- To initiate the migrations, does not actually make it
`docker-compose run --rm djangoapp app/manage.py migrate` <-- To actually make the migraitons

### Django Static files
`docker-compose run --rm djangoapp app/manage.py collectstatic --no-input` this will create the static file for you. If you don't set this your static files in django will not run. You will see a broken css, js when you go to the admin section. 

### Command Difference
1. `docker-compose run --rm djangoapp app/manage.py`
2. `docker-compose run --rm djangoapp /bin/bash -c "cd app; ./manage.py django_commads"`

If you have to run a command on the root folder use the 1st command, and if you want to run the command on the django root project use the 2nd command.

# Miscellaneous

## How to use docker
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

# Next todo for the repos
1. Change the docker iamges to alpine for small image sizes
2. Buster vs Apline images on docker, which one are better?
3. Creating a user in the Dockerfile, so the container is not functioning at the root. Which is security risk.
4. Development and Production eviornment setting
5. move all the ports to the env varaible, or a single source to manipulate them.
6. Right an inital script to check the folder structure is correct, for the docker-compose up --build to run.
7. connecting postgres container with [DBBeaver](https://dbeaver.io/)