# TODO: apline version, for small container size
FROM python:3.6

# TODO: add a continaer user to avoid using root in container
RUN mkdir -p /src

WORKDIR /src

COPY requirements.txt /src/requirements.txt
# RUN pip install gunicorn django
RUN pip install -r requirements.txt

COPY . /src

EXPOSE 8000

CMD ["gunicorn", "--chdir", "app", "--bind", ":8000", "app.wsgi:application"]