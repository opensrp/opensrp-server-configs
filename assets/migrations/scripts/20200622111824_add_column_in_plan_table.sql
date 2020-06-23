-- // add column in plan table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.plan ADD COLUMN is_template BOOLEAN DEFAULT FALSE;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.plan DROP COLUMN is_template;
