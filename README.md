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

    ireal	0m2.021s
    user	0m0.074s
    sys	0m0.102s
    id	select_type	table	type	possible_keys	key	key_len	ref	rows	Extra
    1	SIMPLE	cpw	ref	PRIMARY,CATALOG_PRODUCT_WEBSITE_WEBSITE_ID	CATALOG_PRODUCT_WEBSITE_WEBSITE_ID	2	const	1	Using where; Using index
    1	SIMPLE	cpsd	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cpw.product_id,const,const	1	
    1	SIMPLE	cp	eq_ref	PRIMARY	PRIMARY	4	perftest.cpw.product_id	1	Using where; Using index
    1	SIMPLE	cpss	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cpw.product_id,const,const	1	Using where
    1	SIMPLE	cpvd	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cpw.product_id,const,const	1	
    1	SIMPLE	cpvs	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cpw.product_id,const,const	1	Using where
    1	SIMPLE	ccp	ref	CATALOG_CATEGORY_PRODUCT_PRODUCT_ID	CATALOG_CATEGORY_PRODUCT_PRODUCT_ID	4	perftest.cpw.product_id	2	

Regression in 10.3
==================

    docker-compose exec sql103 bash
    cd /mnt && bash testscript.sh

Output
------

Regression still present in 10.4
================================

    docker-compose exec sql104 bash
    cd /mnt && bash testscript.sh

Output
------

    real	3m44.795s
    user	0m0.079s
    sys	0m0.103s
    id	select_type	table	type	possible_keys	key	key_len	ref	rows	Extra
    1	PRIMARY	<derived3>	ALL	NULL	NULL	NULL	NULL	73584	Start temporary; Using temporary; Using filesort
    1	PRIMARY	cp	eq_ref	PRIMARY	PRIMARY	4	tvc_0._col_1	1	Using where; Using index; End temporary
    1	PRIMARY	cpw	range	PRIMARY,CATALOG_PRODUCT_WEBSITE_WEBSITE_ID	CATALOG_PRODUCT_WEBSITE_WEBSITE_ID	2	NULL	40195	Using where; Using index; Using join buffer (flat, BNL join)
    1	PRIMARY	cpsd	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cp.entity_id,const,const	1	
    1	PRIMARY	cpss	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cp.entity_id,const,const	1	Using where
    1	PRIMARY	cpvd	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cp.entity_id,const,const	1	
    1	PRIMARY	cpvs	eq_ref	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID,CATALOG_PRODUCT_ENTITY_INT_ATTRIBUTE_ID,CATALOG_PRODUCT_ENTITY_INT_STORE_ID	CATALOG_PRODUCT_ENTITY_INT_ENTITY_ID_ATTRIBUTE_ID_STORE_ID	8	perftest.cp.entity_id,const,const	1	Using where
    1	PRIMARY	ccp	ref	CATALOG_CATEGORY_PRODUCT_PRODUCT_ID	CATALOG_CATEGORY_PRODUCT_PRODUCT_ID	4	perftest.cp.entity_id	2	
    3	DERIVED	NULL	NULL	NULL	NULL	NULL	NULL	NULL	No tables used

