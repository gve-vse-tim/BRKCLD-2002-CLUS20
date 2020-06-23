#!/bin/bash

virtualenv --system-site-packages -p python3.6 /var/www/venv
source /var/www/venv/bin/activate

pip3 install -r /var/www/requirements.txt
