# Use the official Ubuntu base image
FROM ubuntu:24.04

# Set the working directory
WORKDIR /app

# Copy your application files into the container
COPY app/ /app

# Update packages
RUN apt-get update

# install webhook
RUN apt-get install -y webhook

# Install Python and necessary dependencies for your Python application
RUN apt-get install -y python3 python3-pip
RUN pip3 install -r requirements.txt

# Command to run your Ubuntu application
CMD ["/usr/bin/webhook", "-nopanic", "-hooks", "/app/webhook.conf", "-hotreload" ,"-verbose"]

# Expose any necessary ports for your applications
EXPOSE 9000
