-- // client table add date_edited
-- Migration SQL that makes the change goes here.

CREATE TABLE core.sample
(
    id bigserial NOT NULL,
    total integer,
    date_deleted timestamp,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};

-- //@UNDO
-- SQL to undo the change goes here.

DROP TABLE core.sample;