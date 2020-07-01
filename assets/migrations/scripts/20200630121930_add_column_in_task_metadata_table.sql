-- // add column in task metadata table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.task_metadata ADD COLUMN code VARCHAR DEFAULT NULL;

CREATE INDEX task_metadata_index ON core.task_metadata(for_entity,plan_identifier,code);

-- //@UNDO
-- SQL to undo the change goes here.

DROP INDEX core.task_metadata_index;

ALTER TABLE core.task_metadata DROP COLUMN code;

