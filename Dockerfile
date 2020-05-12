FROM python:3.8.2-alpine3.11

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

ADD requirements.txt .

RUN apk update
# Postgresql Dependencies for ti to functiona normal
RUN apk add --virtual build-deps gcc python3-dev musl-dev 
RUN apk add postgresql 
RUN apk add postgresql-dev 
# RUN  pip install psycopg2 
# Pillow dependencies for it to function normal
RUN apk add jpeg-dev zlib-dev libjpeg  
# RUN  pip install Pillow 
RUN pip install -r requirements.txt 
RUN apk del build-deps


WORKDIR /home/src
ADD . /home/src

# RUN useradd awg && chown -R awg /home/src
RUN adduser -D awg && chown -R awg /home/
USER awg

EXPOSE 8000

CMD ["gunicorn", "--reload", "--chdir", "app", "--bind", ":8000", "app.wsgi:application"]
