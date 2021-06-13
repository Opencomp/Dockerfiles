# Dockerfiles

Dockerfiles for building Opencomp specific Docker images

## jtraulle/php

PHP Alpine Linux build with all necessary modules and dependencies needed for running an Opencomp instance (bundled with wkhtml2pdf with patched QT).

### PHP 8.0

#### Alpine 3.12

  * `8.0-fpm-alpine3.12`
  * `8.0-fpm-alpine3.12-dev`

#### Alpine 3.13
  
  * `8.0-fpm-alpine3.13`
  * `8.0-fpm-alpine3.13-dev`

Standard images are provided with the following PHP modules : `mbstring` `intl` `simplexml` `mysqli` `pdo` `pdo_mysql` `pdo_pgsql` `zip` `gd` `redis`.

Images suffixed with `-dev` are provided with required dependencies for development (this includes Chromium browser for running acceptance tests and php modules `pcov` and `ast` used to calculate code coverage et [`phan`](https://github.com/phan/phan) static analyzer tool).

## jtraulle/wkhtmltopdf

wkhtml2pdf on Alpine Linux from sources with patched QT for supporting headers and footers.
