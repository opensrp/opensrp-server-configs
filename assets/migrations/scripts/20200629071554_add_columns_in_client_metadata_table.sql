-- // add columns in client metadata table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.client_metadata ADD COLUMN location_id VARCHAR DEFAULT NULL;
ALTER TABLE core.client_metadata ADD COLUMN client_type VARCHAR DEFAULT NULL;

CREATE INDEX client_metadata_location_id_client_type_index ON core.client_metadata(location_id,client_type);
-- //@UNDO
-- SQL to undo the change goes here.

DROP INDEX core.client_metadata_location_id_client_type_index;

ALTER TABLE core.client_metadata DROP COLUMN location_id;
ALTER TABLE core.client_metadata DROP COLUMN client_type;

