-- // add column geometry in location and structure table
-- Migration SQL that makes the change goes here.

create EXTENSION postgis;
ALTER TABLE core.structure ADD COLUMN geometry geometry;
ALTER TABLE core.location ADD COLUMN geometry geometry;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.structure DROP COLUMN geometry;
ALTER TABLE core.location DROP COLUMN geometry;
DROP EXTENSION postgis;


