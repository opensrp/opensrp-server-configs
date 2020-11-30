-- // add product catalogue sequence
-- Migration SQL that makes the change goes here.

CREATE SEQUENCE IF NOT EXISTS core.product_catalogue_server_version_seq;
--POPULATE
SELECT setval('core.product_catalogue_server_version_seq',(SELECT max(server_version )+1 FROM core.product_catalogue ));

-- //@UNDO
-- SQL to undo the change goes here.

DROP SEQUENCE IF EXISTS core.product_catalogue_server_version_seq;

