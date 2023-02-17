-- // client table add date_edited
-- Migration SQL that makes the change goes here.

CREATE TABLE core.sample
(
    id bigserial NOT NULL,
    json jsonb NOT NULL,
    date_deleted timestamp,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};

CREATE INDEX sample_date_deleted_index ON core.sample (date_deleted);

-- //@UNDO
-- SQL to undo the change goes here.

DROP TABLE core.sample;