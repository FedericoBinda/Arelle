# Python support can be specified down to the minor or micro version
# (e.g. 3.6 or 3.6.3).
# OS Support also exists for jessie & stretch (slim and full).
# See https://hub.docker.com/r/library/python/ for all supported Python
# tags from Docker Hub.
FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7

# Running as root. In principle this should be avoided,
# but I will test first if things work this way
# and think later of a better solution for the actual deployment
RUN mkdir /root/.config && mkdir /root/.config/arelle

# Install dev tools required for libxml
RUN apk update && apk add libxml2-dev libxslt-dev python-dev build-base

# Set the port on which the app runs; make both values the same.
#
# IMPORTANT: When deploying to Azure App Service, go to the App Service on the Azure 
# portal, navigate to the Applications Settings blade, and create a setting named
# WEBSITES_PORT with a value that matches the port here (the Azure default is 80).
# You can also create a setting through the App Service Extension in VS Code.
ENV LISTEN_PORT=5000
EXPOSE 5000

# Indicate where uwsgi.ini lives
ENV UWSGI_INI uwsgi.ini

LABEL Name=arelle Version=0.0.1

# Set the folder where uwsgi looks for the app
WORKDIR /

# Copy the app contents to the image
COPY . /

# If you have additional requirements beyond Flask (which is included in the
# base image), generate a requirements.txt file with pip freeze and uncomment
# the next three lines.
COPY requirements.txt /
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r /requirements.txt


