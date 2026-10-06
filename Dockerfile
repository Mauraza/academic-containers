FROM registry.suse.com/bci/bci-base:16.0

LABEL org.opencontainers.image.title="My website"

RUN zypper -n install nginx

COPY --chown=root:root index.html /srv/www/htdocs

WORKDIR /srv/www/htdocs

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
