FROM  centos:8
LABEL maintainer "Tim Miller <timmil@cisco.com>"

WORKDIR /var/www

# Install packages
RUN yum install -y git iproute which python3-pip python3-virtualenv \
    && yum install -y python3-mod_wsgi python3-psycopg2 \
    && yum update -y && yum clean all

# Install required Python modules
COPY requirements.txt requirements.txt
COPY docker/create_python_venv.sh scripts/
RUN bash ${PWD}/scripts/create_python_venv.sh

# Create Django security key
COPY docker/init_django.py scripts/
RUN source venv/bin/activate && python3 scripts/init_django.py

# Copy the latest httpd.conf file
COPY docker/clus20_django.conf /etc/httpd/conf.d/

# Copy the initialization script
COPY docker/init_database.py scripts/

# Copy in latest git repo
COPY clus20_django/ clus20_django/

EXPOSE 80
USER root

CMD [ "/usr/sbin/httpd", "-DFOREGROUND" ]
