-- // add_relationship_column_in_client_form_metadata
-- Migration SQL that makes the change goes here.

ALTER TABLE core.client_form_metadata ADD COLUMN relation VARCHAR DEFAULT NULL;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.client_form_metadata DROP COLUMN relation;

