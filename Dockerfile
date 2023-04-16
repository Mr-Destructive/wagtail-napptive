# Base image
FROM python:3.7-slim-buster

WORKDIR /app
COPY . /app

# Install source package and test suite
RUN python -m pip install --upgrade pip wheel build
RUN pip install --no-cache-dir .[testing]
RUN python -m pip install --upgrade --editable .
RUN python setup.py install

# Run Tests
CMD ["python", "runtests.py"]
