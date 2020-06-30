-- // add columns in event metadata table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.event_metadata ADD COLUMN plan_identifier VARCHAR DEFAULT NULL;

CREATE INDEX event_metadata_plan_identifier_index ON core.event_metadata(plan_identifier);

-- //@UNDO
-- SQL to undo the change goes here.

DROP INDEX core.event_metadata_plan_identifier_index;

ALTER TABLE core.event_metadata DROP COLUMN plan_identifier;

