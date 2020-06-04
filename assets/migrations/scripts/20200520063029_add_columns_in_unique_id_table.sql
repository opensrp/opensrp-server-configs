-- // add columns in unique_id table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.unique_id ADD COLUMN identifier VARCHAR;

ALTER TABLE core.unique_id ADD COLUMN id_source bigint DEFAULT NULL;

ALTER TABLE core.unique_id ADD COLUMN is_reserved BOOLEAN DEFAULT FALSE;

ALTER TABLE core.unique_id ADD CONSTRAINT fk_identifier_source_id FOREIGN KEY (id_source) REFERENCES core.identifier_source(id);

CREATE INDEX unique_id_identifier_index ON core.unique_id (identifier);

-- //@UNDO
-- SQL to undo the change goes here.
ALTER TABLE core.unique_id DROP CONSTRAINT fk_identifier_source_id;

DROP INDEX IF EXISTS core.unique_id_identifier_index;

ALTER TABLE core.unique_id DROP COLUMN identifier;

ALTER TABLE core.unique_id DROP COLUMN id_source;

ALTER TABLE core.unique_id DROP COLUMN is_reserved;
