-- // add columns in event metadata table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.event_metadata ADD COLUMN plan_identifier VARCHAR DEFAULT NULL;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.event_metadata DROP COLUMN plan_identifier;

