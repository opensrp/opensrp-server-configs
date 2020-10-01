-- // add column sequence value in identifier source table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.identifier_source ADD COLUMN  sequence_value bigint;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.identifier_source DROP COLUMN sequence_value;
