# TODO: apline version, for small container size
FROM python:3.8.2-alpine3.11

# TODO: add a continaer user to avoid using root in container
RUN mkdir -p /src

WORKDIR /src

COPY requirements.txt /src/requirements.txt

RUN \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 python3 -m pip install -r requirements.txt --no-cache-dir && \
 apk --purge del .build-deps
# RUN pip install gunicorn django
# RUN pip install -r requirements.txt

COPY . /src

EXPOSE 8000

CMD ["gunicorn", "--chdir", "app", "--bind", ":8000", "app.wsgi:application"]