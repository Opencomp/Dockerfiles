#!/bin/bash

while : ; do
    [[ -f "/var/www/html/vendor/autoload.php" ]] && break
    echo "Waiting for end of composer dependencies installation ..."
    sleep 1
done

/var/www/html/bin/cake generate_pupil_report -v
