FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default
COPY ./tools/nginx.sh /var/www

EXPOSE 443

RUN chmod +x /var/www/nginx.sh

ENTRYPOINT ["/var/www/nginx.sh"]