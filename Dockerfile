FROM python:3.7-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app
COPY . /app

RUN python -m pip install --upgrade pip wheel build
RUN pip install --no-cache-dir .[full]
RUN pip install --no-cache-dir .[testing]
RUN python runtests.py

RUN wagtail start example

RUN echo "\n\
DATABASES = {\n\
    'default': {\n\
        'ENGINE': 'django.db.backends.postgresql',\n\
        'NAME': 'wagtail',\n\
        'USER': 'postgres',\n\
        'PASSWORD': 'postgres',\n\
        'HOST': 'db',\n\
        'PORT': '5432',\n\
    }\n\
}\n\
" >> /app/example/example/settings.py

RUN cd example && python manage.py migrate
RUN cd example && echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'password')" | python manage.py shell
RUN cd example && python manage.py collectstatic --noinput

EXPOSE 8000
CMD ["sh", "-c", "cd example && python manage.py runserver 0.0.0.0:8000"]
