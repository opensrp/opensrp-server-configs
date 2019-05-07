#!/bin/bash

sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >  /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt-get -yq update

sudo apt-get -yq install libjson0 libjson0-dev

sudo apt-get -yq install postgresql-10

sudo apt-get -yq  install postgresql-client-10 postgresql-10-postgis-2.4 postgresql-10-postgis-2.4-scripts