-- // add is draft and is json validator flags
-- Migration SQL that makes the change goes here.

ALTER TABLE core.client_form_metadata ADD COLUMN is_draft BOOLEAN default false;
ALTER TABLE core.client_form_metadata ADD COLUMN is_json_validator BOOLEAN default false;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.client_form_metadata DROP COLUMN is_draft;
ALTER TABLE core.client_form_metadata DROP COLUMN is_json_validator;


