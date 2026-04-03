FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	php8.2-fpm \
	php8.2-mysql \
	mariadb-client \
	wget && \
	rm -rf /var/lib/apt/lists/*

COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]
