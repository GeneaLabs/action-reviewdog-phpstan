#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
    cd "${GITHUB_WORKSPACE}" || exit
    git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ ! -f ./phpstan.dist.neon ]
then
    cp /config/phpstan.dist.neon "${GITHUB_WORKSPACE}/phpstan.dist.neon"
fi

cp /config/phpstan.neon "${GITHUB_WORKSPACE}/phpstan.neon"

php /composer/vendor/phpstan/phpstan/phpstan.phar analyse ${INPUT_TARGET_DIRECTORY} --level=${INPUT_PHPSTAN_LEVEL} --memory-limit 1G --error-format=raw ${INPUT_ARGS} \
    | reviewdog -name=PHPStan -f=phpstan -reporter=${INPUT_REPORTER} -fail-on-error=${INPUT_FAIL_ON_ERROR} -level=${INPUT_LEVEL} -diff='git diff'
