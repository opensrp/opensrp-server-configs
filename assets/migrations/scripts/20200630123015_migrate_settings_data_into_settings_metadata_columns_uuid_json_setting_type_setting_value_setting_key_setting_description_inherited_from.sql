--
--    Copyright 2010-2016 the original author or authors.
--
--    Licensed under the Apache License, Version 2.0 (the "License");
--    you may not use this file except in compliance with the License.
--    You may obtain a copy of the License at
--
--       http://www.apache.org/licenses/LICENSE-2.0
--
--    Unless required by applicable law or agreed to in writing, software
--    distributed under the License is distributed on an "AS IS" BASIS,
--    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--    See the License for the specific language governing permissions and
--    limitations under the License.
--

-- // migrate_settings_data_into_settings_metadata_columns_uuid_json_setting_type_setting_value_setting_key_setting_description_inherited_from
-- Migration SQL that makes the change goes here.

SET client_min_messages TO WARNING;

-- Sometimes the uuid-ossp extension does not have the uuid_generate_v4() function so we delete & re-create it in order to
-- generate the uuid_generate_v4() function
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" schema core;

-- remove document_id uniqueness constraint
ALTER TABLE IF EXISTS core.settings_metadata
    DROP CONSTRAINT IF EXISTS settings_metadata_document_id_key;

CREATE OR REPLACE FUNCTION core.migrate_settings_json()
    RETURNS VOID
AS
$$

DECLARE
    setting_configurations jsonb;
    setting                jsonb;
    setting_id             bigint;
    document_id            varchar;
    settings_fk            bigint;
    identifier             varchar;
    team                   varchar;
    team_id                varchar;
    server_version         bigint;
    provider_id            varchar;
    location_id            varchar;
    setting_key            varchar;
    setting_value          varchar;
    setting_description    varchar;
    setting_label          varchar;
    setting_type           varchar;
    uuid                   varchar;
    inherited_from         varchar;
    setting_json           jsonb;


BEGIN
    -- create backup tables
    CREATE TABLE IF NOT EXISTS core.settings_backup as TABLE core.settings;
    CREATE TABLE IF NOT EXISTS core.settings_metadata_backup as TABLE core.settings_metadata;

    -- delete entries from v1 data
    DELETE FROM core.settings_metadata sm WHERE sm.uuid IS NULL;

    -- migrate data
    FOR setting_id, setting_configurations IN (SELECT id, json from core.settings)
        LOOP
            FOR setting IN SELECT * FROM jsonb_array_elements((setting_configurations ->> 'settings')::jsonb)
                LOOP
                    document_id := setting_configurations ->> '_id';
                    settings_fk := setting_id;
                    identifier := setting_configurations ->> 'identifier';
                    team := setting_configurations ->> 'team';
                    team_id := setting_configurations ->> 'teamId';
                    server_version := setting_configurations ->> 'serverVersion';
                    provider_id := setting_configurations ->> 'providerId';
                    location_id := setting_configurations ->> 'locationId';
                    setting_key := setting ->> 'key';

                    IF setting ->> 'value' IS NOT NULL THEN
                        setting_value := setting ->> 'value';
                    END if;

                    IF setting ->> 'values' IS NOT NULL THEN
                        setting_value := setting ->> 'values';
                    END if;

                    setting_description := setting ->> 'description';
                    setting_label := setting ->> 'label';
                    setting_type := setting ->> 'type';
                    uuid := setting ->> 'uuid';
                    inherited_from := setting ->> 'inherited_from';
                    setting_json := jsonb_pretty(setting);

                    IF uuid IS NULL THEN
                        uuid := core.uuid_generate_v4();
                    END IF;

                    INSERT INTO core.settings_metadata (document_id, settings_id, identifier, team, team_id, server_version,
                                                   provider_id,
                                                   location_id, setting_key, setting_value, setting_description,
                                                   setting_label, setting_type, uuid, inherited_from, json)
                    VALUES (document_id, settings_fk, identifier, team, team_id, server_version, provider_id, location_id,
                            setting_key, setting_value, setting_description, setting_label, setting_type, uuid,
                            inherited_from, setting_json)
                    ON CONFLICT DO NOTHING;

                END LOOP;
        END LOOP;

    -- delete settings block since migration is complete
    UPDATE core.settings SET json=json - 'settings';
END;

$$ LANGUAGE 'plpgsql';

SELECT core.migrate_settings_json();

-- //@UNDO
-- SQL to undo the change goes here.
DROP TABLE IF EXISTS core.settings CASCADE;
DROP TABLE IF EXISTS core.settings_metadata;

CREATE TABLE IF NOT EXISTS core.settings AS TABLE core.settings_backup;
ALTER TABLE IF EXISTS core.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (id);
CREATE TABLE IF NOT EXISTS core.settings_metadata AS TABLE settings_metadata_backup;
ALTER TABLE IF EXISTS core.settings_metadata
    ADD CONSTRAINT settings_metadata_pk PRIMARY KEY (id);
ALTER TABLE IF EXISTS core.settings_metadata
    ADD CONSTRAINT settings_fk FOREIGN KEY (settings_id) REFERENCES core.settings (id) ON DELETE CASCADE;

CREATE SEQUENCE IF NOT EXISTS core.settings_id_seq;
ALTER TABLE IF EXISTS core.settings
    ALTER COLUMN id SET DEFAULT nextval('core.settings_id_seq');
ALTER SEQUENCE IF EXISTS core.settings_id_seq OWNED BY core.settings.id;

CREATE SEQUENCE IF NOT EXISTS core.settings_metadata_id_seq;
ALTER TABLE IF EXISTS core.settings_metadata
    ALTER COLUMN id SET DEFAULT nextval('core.settings_metadata_id_seq');
ALTER SEQUENCE IF EXISTS core.settings_metadata_id_seq OWNED BY core.settings_metadata.id;

DROP TABLE IF EXISTS core.settings_metadata_backup;
DROP TABLE IF EXISTS core.settings_backup CASCADE;
