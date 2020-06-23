#!/bin/bash

source scl_source enable httpd24
exec "$@"
