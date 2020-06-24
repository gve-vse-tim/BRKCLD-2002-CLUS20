# BRKCLD-2002-CLUS20

Code to support Cisco Live US 2020 Digital Broadcast session BRKCLD-2002, Demystifying Application Modeling and Workload Management in CloudCenter Suite

## Docker

Components required to build a Docker container for the Django application.
Also contains the various artifacts needed to configure the service when
deployed by CloudCenter

- create_python_venv.sh: used to create the required Python virtual environment
  based on CentOS/RedHat Software Collections Python 3.6 and Apache httpd 2.4
- clu20_django.conf: The Apache configuration fragment needed for this sample
  application.
- init_database.py: Python based script to force database schema initialization
  and synchronization with the PgSQL server
- init_django.py: Create a random secret_key.txt file automatically so that it
  won't be stored in the code repository.

See the [README.md](docker/README.md) for instructions on building and running
the application on your local laptop's Docker installation.

## clus20_django

Sample application based on a shortened implementation of Django Project's
[Writing your first Django app tutorial](https://docs.djangoproject.com/en/3.0/intro/tutorial01/)

### Requirements

With a CentOS 8 based image, the mod_wsgi and psycopg2 python modules are
provided by the operating system package manager and including in the virtual
environment via **--system-site-packages** option to **virtualenv**

- Python >= 3.6
- Psycopg2 >= 2.7
- Django >= 3.0
- Apache 2.4
- mod_wsgi with Python 3 support

### Application initialization

A secret_key.txt must be provided to the application and store in the location
**/var/www/secret_key.txt**.  Currently, we create this file automatically via the
**init_django.py** script.

- django-admin startproject clus20_django
- python manage.py startapp polls
- Population content from Django tutorial site
- python docker/init_database.py
  - python manage.py makemigrations polls
  - python manage.py migrate
  - python manage.py createsuperuser
  - Adds some poll questions

