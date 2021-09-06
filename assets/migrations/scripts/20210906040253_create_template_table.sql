-- // create template table
-- Migration SQL that makes the change goes here.

CREATE TABLE core.template
(
	id bigserial NOT NULL,
    template_id int UNIQUE NOT NULL,
    template jsonb NOT NULL,
    type character varying NOT NULL default 'plan',
    version int,
    date_created timestamp DEFAULT NOW(),
    date_edited timestamp DEFAULT NOW(),
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};


-- //@UNDO
-- SQL to undo the change goes here.

DROP TABLE core.template;

