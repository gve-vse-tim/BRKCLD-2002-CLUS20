#!/bin/bash
#
# Assumptions:
#  - App Package directory is /opt/remoteFiles/appPackage/BRKCLD-2002-CLUS20
#    - GitHub repository name (github.com/gve-vse-tim/BRKCLD-2002-CLUS20)
#  - This script is run with root privileges
#  - This script is executed AFTER the database (clus20_database) is created

CCSWM_AGENT=/usr/local/agentlite
CCSWM_PARENT=/opt/remoteFiles/appPackage
PARENT_SRC=${CCSWM_PARENT}/BRKCLD-2002-CLUS20-3.0
WEB_ROOT=/var/www
HTTPD_CONFD=/etc/apache2/sites-available

# Import CloudCenter deployment variables
source ${CCSWM_AGENT}/etc/userenv

# Create Database Host Entry
DB_HOST=${CliqrDependencies}
IP_VAR=CliqrTier_${DB_HOST}_IP
DB_IP=${!IP_VAR}
echo "${DB_IP}   ${DB_HOST}" >> /etc/hosts

# Software installation
sudo apt-get install -y git iproute2 python3-pip virtualenv \
    apache2 libapache2-mod-wsgi-py3

sudo apt-get install -y python-dev default-libmysqlclient-dev mysql-client

# Create Python Virtual Environment
if ! /usr/bin/test -d ${WEB_ROOT}; then
    /bin/mkdir -p ${WEB_ROOT}
fi

# Create Python virtual environment
/bin/cp ${PARENT_SRC}/requirements.txt ${WEB_ROOT}
/bin/bash ${PARENT_SRC}/docker/create_python_venv.sh

# Initialize Django secret key
source ${WEB_ROOT}/venv/bin/activate
python3 ${PARENT_SRC}/docker/init_django.py

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
