FROM python:3.7-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app
COPY . /app

RUN python -m pip install --upgrade pip wheel build
RUN pip install --no-cache-dir .[full]

RUN wagtail start example

RUN cd example && python manage.py migrate
RUN cd example && echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'password')" | python manage.py shell
RUN cd example && python manage.py collectstatic --noinput

EXPOSE 8000
#CMD ["cd", "example", "&&", "python", "manage.py", "runserver", "0.0.0.0:8000"]
CMD ["sh", "-c", "cd example && python manage.py runserver 0.0.0.0:8000"]
