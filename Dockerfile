FROM nginx:1.16

# Set variables
ENV DOCKERIZE_VERSION v0.6.1
ENV NOT_FOUND_MEANS_INDEX "false"

# Update system
RUN apt-get update \
    && apt-get install -y \
    wget \
    && rm -r /var/lib/apt/lists/*

# Install dockerize to parse the template
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Copy Nginx template file to container
COPY src/nginx.conf.tmpl /etc/nginx/nginx.conf.tmpl

# Parse the template
ENTRYPOINT ["dockerize", \
    "-template", \
    "/etc/nginx/nginx.conf.tmpl:/etc/nginx/nginx.conf"]

# Run Nginx
CMD ["nginx", \
    "-g", \
    "daemon off;"]
