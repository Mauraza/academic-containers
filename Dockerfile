FROM debian:stable-slim

LABEL maintainer "Webmaster webmaster@example.com" 
  
RUN apt-get update && apt-get install -y nginx curl
  
COPY index.html /var/www/html 
  
EXPOSE 80 
WORKDIR /var/www/html 
  
ENTRYPOINT ["nginx"] 
CMD ["-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]