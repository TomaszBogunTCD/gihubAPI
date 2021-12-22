FROM ubuntu:20.04

#download and install programs
RUN apt-get update -y
RUN apt-get install -y unzip curl git wget python3 python3-pip python-dev

#copies list of python requirements
COPY requirements.txt /app/requirements.txt

WORKDIR /app

# installs python requirements
RUN pip3 install -r requirements.txt
RUN pip3 install flask

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

#Set GITHUB_API_TOKEN environment variable
#replace TOKEN with own github API token
RUN export GITHUB_API_TOKEN=TOKEN

#copies everything
COPY . /app
#builds web application
RUN flutter build web

EXPOSE 5000
EXPOSE 55555

ENTRYPOINT ["/app/script.sh"]