-- // add column in plan table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.plan ADD COLUMN experimental BOOLEAN DEFAULT FALSE;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.plan DROP COLUMN experimental;
