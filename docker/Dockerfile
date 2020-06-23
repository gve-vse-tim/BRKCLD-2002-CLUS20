FROM  centos:7
LABEL maintainer "Tim Miller <timmil@cisco.com>"

WORKDIR /var/www

# Install packages
# RUN yum install -y git httpd python3-pip python-virtualenv \
#         && yum install -y iproute centos-release-scl \
#         && yum install -y rh-python36-mod_wsgi \
#         && yum update -y \
#         && yum clean all
RUN yum install -y git iproute which centos-release-scl \
    && yum install -y rh-python36-mod_wsgi rh-python36-python-virtualenv \
    && yum install -y rh-python36-python-psycopg2 \
    && yum update -y && yum clean all

# Install required Python modules
COPY docker/requirements.txt requirements.txt
COPY docker/create_python_venv.sh create_python_venv.sh
RUN bash create_python_env.sh

# Bring in the entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh

# Copy Django security key
COPY docker/init_django.py init_django.py
RUN ./init_django.py

# Copy the latest httpd.conf file
COPY docker/clus20_django.conf /opt/rh/httpd24/root/etc/httpd/conf.d/

# Copy in latest git repo
COPY clus20_django/ clus20_django/

EXPOSE 80
USER root

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "httpd", "-DFOREGROUND" ]
