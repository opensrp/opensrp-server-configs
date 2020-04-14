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

-- // add settings metadata columns uuid json setting type setting value setting key setting description inherited from
-- Migration SQL that makes the change goes here.
ALTER TABLE core.settings_metadata ADD COLUMN uuid VARCHAR NOT NULL;
ALTER TABLE core.settings_metadata ADD COLUMN json jsonb NOT NULL;
ALTER TABLE core.settings_metadata ADD COLUMN setting_type VARCHAR;
ALTER TABLE core.settings_metadata ADD COLUMN setting_value VARCHAR;
ALTER TABLE core.settings_metadata ADD COLUMN setting_key VARCHAR;
ALTER TABLE core.settings_metadata ADD COLUMN setting_description VARCHAR;
ALTER TABLE core.settings_metadata ADD COLUMN inherited_from VARCHAR;

-- Add search fields index
ALTER TABLE core.settings_metadata ADD INDEX settings_search_fields_index (uuid, setting_type, setting_key);


-- //@UNDO
-- SQL to undo the change goes here.
ALTER TABLE core.settings_metadata DROP COLUMN uuid VARCHAR NOT NULL;
ALTER TABLE core.settings_metadata DROP COLUMN json jsonb NOT NULL;
ALTER TABLE core.settings_metadata DROP COLUMN setting_type VARCHAR;
ALTER TABLE core.settings_metadata DROP COLUMN setting_value VARCHAR;
ALTER TABLE core.settings_metadata DROP COLUMN setting_key VARCHAR;
ALTER TABLE core.settings_metadata DROP COLUMN setting_description VARCHAR;
ALTER TABLE core.settings_metadata DROP COLUMN inherited_from VARCHAR;


