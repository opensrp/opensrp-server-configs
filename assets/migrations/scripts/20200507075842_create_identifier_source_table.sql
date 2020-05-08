-- // create identifier source table
-- Migration SQL that makes the change goes here.

CREATE TABLE core.identifier_source
(   
    id bigserial NOT NULL,
    identifier character varying UNIQUE NOT NULL,
    description character varying,
    identifier_validator_algorithm character varying,
    base_character_set character varying NOT NULL,
    first_identifier_base character varying,
    prefix character varying,
    suffix character varying,
    min_length int NOT NULL,
    max_length int NOT NULL,
    blacklisted character varying,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};



-- //@UNDO
-- SQL to undo the change goes here.
DROP TABLE core.identifier_source;


