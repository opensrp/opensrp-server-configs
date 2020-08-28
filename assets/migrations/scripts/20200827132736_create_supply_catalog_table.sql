-- // create supply catalog table
-- Migration SQL that makes the change goes here.

CREATE TABLE core.supply_catalog
(
    id character varying NOT NULL,
    product_name character varying NOT NULL,
    type character varying NOT NULL,
    unique_id bigserial NOT NULL ,
    json jsonb NOT NULL,
    server_version bigint,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};


-- //@UNDO
-- SQL to undo the change goes here.

DROP TABLE core.supply_catalog;
