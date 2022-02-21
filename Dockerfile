FROM debian:9-slim
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        apt-transport-https \
        wget \
        gnupg2 \
        dirmngr \
        ca-certificates \
        libfontconfig1
# Node.js is required to run this application.
RUN echo "# Node.js 14.x for Debian 9 (codename stretch)" > /etc/apt/sources.list.d/nodejs.list \
  && echo "deb https://deb.nodesource.com/node_14.x stretch main" >> /etc/apt/sources.list.d/nodejs.list \
  && echo "deb-src https://deb.nodesource.com/node_14.x stretch main" >> /etc/apt/sources.list.d/nodejs.list
RUN apt-key adv --fetch-keys https://deb.nodesource.com/gpgkey/nodesource.gpg.key
RUN apt-get update && apt-get install --no-install-recommends -y nodejs
# Create directory for application.
RUN mkdir -p /opt/export-client
# Copy all files to that directory.
COPY export-client /opt/export-client
WORKDIR /opt/export-client/scripts
# Install required Node.js packages (basically PhantomJS).
RUN if [ "$(arch)" != "armv7l" ]; then npm install && rm -rf /tmp/phantom*; else apt-get install -y phantomjs --no-install-recommends --no-install-suggests; fi
RUN npm install -S yargs
RUN npm install -S yamljs
RUN npm install -S jsdom 
RUN npm install -S jquery
# Start
CMD node export_images.js
