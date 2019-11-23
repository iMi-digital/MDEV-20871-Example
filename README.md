Reproducible Example for MariaDB MDEV-20871
===========================================

https://jira.mariadb.org/browse/MDEV-20871a


Instructions:

docker-compose up -d


Unproblematic in 10.2
=====================

    docker-compose exec sql102 bash
    cd /mnt && bash testscript.sh

Output
------

Regression in 10.3
==================

    docker-compose exec sql103 bash
    cd /mnt && bash testscript.sh

Output
------

Regression still present in 10.4
================================

    docker-compose exec sql102 bash
    cd /mnt && bash testscript.sh

Output
------
