#!/bin/bash

while : ; do
    [[ -f "/var/www/html/Vendor/autoload.php" ]] && break
    echo "Waiting for end of composer dependencies installation ..."
    sleep 1
done

/var/www/html/Console/cake generate_pupil_report -v 
