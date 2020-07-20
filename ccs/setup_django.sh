#!/bin/bash
#
# Assumptions:
#  - App Package directory is /opt/remoteFiles/appPackage/BRKCLD-2002-CLUS20-x.y
#    - GitHub repository name (github.com/gve-vse-tim/BRKCLD-2002-CLUS20)
#    - x.y defined by the repo tag
#  - This script is run as cliquser
#  - This script is executed AFTER the database (clus20_database) is created
#    by the MySQL database service initialization.  (create and assign privs)
#  - This script will create all the tables and seed data in that database

if [ x"$1" == "x" ]; then
    REPO_VERS="$1"
else
    REPO_VERS="4.0"
fi

# Import CloudCenter deployment variables
CCSWM_AGENT=/usr/local/agentlite
source ${CCSWM_AGENT}/etc/userenv

CCSWM_PARENT=/opt/remoteFiles/appPackage
PARENT_SRC=${CCSWM_PARENT}/BRKCLD-2002-CLUS20-${REPO_VERS}

WEB_ROOT=/var/www
HTTPD_CONFD=/etc/apache2/sites-available

# Create Database Host Entry
DB_HOST=${CliqrDependencies}
IP_VAR=CliqrTier_${DB_HOST}_IP
DB_IP=${!IP_VAR}
sudo su -c "echo '${DB_IP}   ${DB_HOST}' >> /etc/hosts"

# Software installation
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git rsync iproute2 \
    python3-pip virtualenv apache2 libapache2-mod-wsgi-py3

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python-dev default-libmysqlclient-dev mysql-client

# Create Python Virtual Environment
if ! /usr/bin/test -d ${WEB_ROOT}; then
    sudo /bin/mkdir -p ${WEB_ROOT}
fi

# Create Python virtual environment
sudo /bin/cp ${PARENT_SRC}/requirements.txt ${WEB_ROOT}
sudo /bin/bash ${PARENT_SRC}/docker/create_python_venv.sh

# Initialize Django secret key
sudo su -c "source ${WEB_ROOT}/venv/bin/activate && python3 ${PARENT_SRC}/docker/init_django.py"

# Copy website code to final destination
sudo /bin/cp -r ${PARENT_SRC}/clus20_django ${WEB_ROOT}

# Copy connection info to proper destination
sudo /bin/cp ${PARENT_SRC}/docker/mysql-connection.json ${WEB_ROOT}/connection.json

# Populate the Django DB
sudo su -c "source ${WEB_ROOT}/venv/bin/activate && python3 ${PARENT_SRC}/docker/init_database.py"

# Copy Django3 Apache configuration file
if ! /usr/bin/test -d ${HTTPD_CONFD}; then
    /bin/echo "Apache configuration directory missing"
    exit 1
fi

# Configure Apache httpd web server
sudo /bin/cp ${PARENT_SRC}/docker/clus20_django.conf /etc/apache2/sites-available
sudo /usr/sbin/a2dissite 000-default
sudo /usr/sbin/a2ensite clus20_django
sudo /bin/systemctl reload apache2
