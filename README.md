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
To run Django commands against the container. We can use the `docker-compose run` command for we can use the `docker exec` command.

### Docker EXEC command
`docker exec -it django_container_id ./manage.py django_command`
1. The django command can be creating a new app.
2. The django command can be running migrations.
3. The django command can be creating the super user.

> Example for django commands.(Most common onces)
1. `docker exec -it django_container_id ./manage.py collectstatic --no-input`
2. `docker exec -it django_container_id ./manage.py createsuperuser`
3. `docker exec -it django_container_id ./manage.py showmigrations`
4. `docker exec -it django_container_id ./manage.py makemigrations`
5. `docker exec -it django_container_id ./manage.py migrate`
6. `docker exec -it django_container_id ./manage.py createapp foo`

You ge the idea.

### Docker-compose run
My docker-compose command sometimes run, and sometimes doesn't. This is due my lack of experince of using docker-compose. I will update this README.md file once I find out what am I doing wrong. For now following is the docker-compose version of running that command.
`docker-compose run --rm djangoaapp ./manage.py django_command`
We use the `--rm` flag to remove the container once the command has ran. The djangoapp name is the name of the web service in the docker-compose.yml file.

# Miscellaneous

## DBBeaver
Connecting postgres container to DBeaver. Use the the following settings
1. HOST: localhost
2. Database: Get it from the `db_env`
3. User: Get it from the `db_env`
4. Password: Get it from the `db_env`

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

`gunicorn --bind :8000 app.wsgi:application` <-- This command needs to be run in the main django project where the `manage.py` file exsists.
`gunicorn --chdir app --bind :8000 app.wsgi.application` <-- This command is run from the root of the project, that is why we change directory to the django project.

# How to use Docker-Compose
To use more then 1 service in docker, you need to create a `docker-compose.yml` file. This files has all the configurations. For this current project will use `nginx` for routing our traffic. 
The key idea in the docker file are
1. Volume mounting
2. Network bridging

For us to achive this, we set the nginx setting th config folder, and the yml file, we use volume, for the app to be sync better the container and local dev environment.

Networking bridging allows us to use the multiple containers for the nginx if need, and the same bridging idea would be applicable when we link out databases.


# Next todo for the repos
1. ~~Change the docker iamges to alpine for small image sizes~~
2. ~~Buster vs Apline images on docker, which one are better?~~
3. Creating a user in the Dockerfile, so the container is not functioning at the root. Which is security risk.
4. Development and Production eviornment setting
5. move all the ports to the env varaible, or a single source to manipulate them.
6. Right an inital script to check the folder structure is correct, for the docker-compose up --build to run.
7. ~~connecting postgres container with [DBBeaver](https://dbeaver.io/)~~
