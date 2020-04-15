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
SET search_path to core;

CREATE OR REPLACE FUNCTION parse_json ()
RETURNS VOID
AS
$$

  DECLARE setting_configurations jsonb;
  DECLARE setting jsonb;
  DECLARE setting_id bigint;

  BEGIN
    FOR setting_id, setting_configurations IN (SELECT id, json from settings)
    LOOP
        FOR setting IN SELECT * FROM jsonb_array_elements((setting_configurations->>'settings')::jsonb)
        LOOP
           RAISE NOTICE 'document_id: %', setting_configurations->>'_id';
           RAISE NOTICE 'setting_id %', setting_id;
           RAISE NOTICE 'identifier: %', setting_configurations->>'identifier';
           RAISE NOTICE 'team: %', setting_configurations->>'team';
           RAISE NOTICE 'team_id: %', setting_configurations->>'teamId';
           RAISE NOTICE 'provider_id: %', setting_configurations->>'providerId';
           RAISE NOTICE 'location_id: %', setting->>'locationId';
           RAISE NOTICE 'setting_key: %', setting->>'key';
           RAISE NOTICE 'setting_value: %', setting->>'value';
           RAISE NOTICE 'setting_description: %', setting->>'description';
           RAISE NOTICE 'setting_type: %', setting->>'type';
           RAISE NOTICE 'uuid: %', setting->>'uuid';
           RAISE NOTICE 'json: %', jsonb_pretty(setting);
        --   INSERT into settings_metadata () VALUES ();
        END LOOP;
    END LOOP;
  END;

$$ LANGUAGE 'plpgsql';

SELECT parse_json();


-- //@UNDO
-- SQL to undo the change goes here.


