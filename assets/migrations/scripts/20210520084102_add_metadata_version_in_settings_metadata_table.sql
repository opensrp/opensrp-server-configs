-- // add metadata_version in settings_metadata table
-- Migration SQL that makes the change goes here.

CREATE SEQUENCE IF NOT EXISTS core.setting_metadata_version_seq START 1;
ALTER TABLE core.settings_metadata ADD COLUMN IF NOT EXISTS metadata_version bigint DEFAULT nextval('core.setting_metadata_version_seq');

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.settings_metadata DROP COLUMN metadata_version;
DROP SEQUENCE IF EXISTS core.setting_metadata_version_seq;
