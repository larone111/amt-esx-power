# Use the official Ubuntu base image
FROM arm64v8/ubuntu:24.04

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
RUN pip3 install -r requirements.txt --break-system-packages

# Command to run your Ubuntu application
CMD ["/usr/bin/webhook", "-nopanic", "-hooks", "/app/webhook.conf", "-hotreload" ,"-verbose"]

# Expose any necessary ports for your applications
EXPOSE 9000

LABEL org.opencontainers.image.source https://github.com/domb84/amt-esx-power