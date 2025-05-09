# Use a lightweight Nginx base image
FROM nginx:alpine

# Copy index.html to the nginx HTML directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
