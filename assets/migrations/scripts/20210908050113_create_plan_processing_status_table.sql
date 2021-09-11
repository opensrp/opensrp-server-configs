-- // create plan processing status table
-- Migration SQL that makes the change goes here.

CREATE TABLE core.plan_processing_status
(
	id bigserial NOT NULL,
    plan_id bigint REFERENCES core.plan(id),
    event_id bigint NOT NULL  REFERENCES core.plan(id),
    template_id bigint NOT NULL  REFERENCES core.template(id),
    status int NOT NULL default 0,
    date_created timestamp DEFAULT NOW(),
    date_edited timestamp DEFAULT NOW(),
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};

comment on column core.plan_processing_status.status is 'initial - 0 | processing - 1 | complete 2';

-- //@UNDO
-- SQL to undo the change goes here.

DROP TABLE IF EXISTS core.plan_processing_status;

