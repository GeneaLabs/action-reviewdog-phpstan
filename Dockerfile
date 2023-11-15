FROM php:8.2-alpine

ENV REVIEWDOG_VERSION=v0.9.17

RUN apk --no-cache add git
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/
RUN wget -c https://github.com/phpstan/phpstan/releases/latest/download/phpstan.phar && mv phpstan.phar /usr/local/bin

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
