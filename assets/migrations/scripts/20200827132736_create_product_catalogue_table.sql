-- // create supply catalog table
-- Migration SQL that makes the change goes here.

CREATE TABLE core.product_catalogue
(
    unique_id bigserial NOT NULL,
    product_name character varying UNIQUE NOT NULL,
    json jsonb NOT NULL,
    server_version bigint,
    PRIMARY KEY (unique_id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};


-- //@UNDO
-- SQL to undo the change goes here.

DROP TABLE core.product_catalogue;
