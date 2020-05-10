# TODO: apline version, for small container size
FROM python:3.8.2-alpine3.11

# TODO: add a continaer user to avoid using root in container
RUN mkdir -p /src

WORKDIR /src

COPY requirements.txt /src/requirements.txt

# To install postgres and Pillow dependencies
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add postgresql \
    && apk add postgresql-dev \
    && pip install psycopg2 \
    && apk add jpeg-dev zlib-dev libjpeg \
    && pip install Pillow \
    && pip install -r requirements.txt \
    && apk del build-deps

COPY app/ /src

EXPOSE 8000

CMD ["gunicorn", "--reload", "--chdir", "app", "--bind", ":8000", "app.wsgi:application"]