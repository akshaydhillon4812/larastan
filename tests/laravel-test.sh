#!/bin/bash

set -e

# Prevent shallow repository error
git fetch --unshallow

# Install Laravel
composer create-project --quiet --prefer-dist "laravel/laravel" laravel
cd laravel/

# Add package from source
sed -e 's|"type": "project",|&\n"repositories": [ { "type": "vcs", "url": "../" } ],|' -i composer.json
composer require --dev "nunomaduro/larastan:dev-master#${TRAVIS_COMMIT}"

# Fix https://github.com/laravel/framework/pull/23825
sed -e 's|@return \\Illuminate\\Http\\Response$|@return \\Symfony\\Component\\HttpFoundation\\Response|' \
    -i app/Exceptions/Handler.php

# Test Laravel
php artisan code:analyse --level=max