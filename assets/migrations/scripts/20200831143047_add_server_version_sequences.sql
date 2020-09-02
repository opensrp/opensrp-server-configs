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

-- // add_server_version_sequences
-- Migration SQL that makes the change goes here.
--Create Sequences
CREATE SEQUENCE IF NOT EXISTS core.event_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.client_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.location_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.stucture_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.plan_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.task_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.setting_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.stock_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.report_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS core.view_config_server_version_seq;

--populate sequences with Max server versions
SELECT setval('core.event_server_version_seq',(SELECT max(server_version )+1 FROM core.event_metadata));
SELECT setval('core.client_server_version_seq',(SELECT max(server_version )+1 FROM core.client_metadata));
SELECT setval('core.location_server_version_seq',(SELECT max(server_version )+1 FROM core.location_metadata));
SELECT setval('core.stucture_server_version_seq',(SELECT max(server_version )+1 FROM core.structure_metadata));
SELECT setval('core.plan_server_version_seq',(SELECT max(server_version )+1 FROM core.plan p ));
SELECT setval('core.task_server_version_seq',(SELECT max(server_version )+1 FROM core.task_metadata));
SELECT setval('core.setting_server_version_seq',(SELECT max(server_version )+1 FROM core.settings_metadata));
SELECT setval('core.stock_server_version_seq',(SELECT max(server_version )+1 FROM core.stock_metadata));
SELECT setval('core.report_server_version_seq',(SELECT max(server_version )+1 FROM core.report_metadata));
SELECT setval('core.view_config_server_version_seq',(SELECT max(server_version )+1 FROM core.view_configuration_metadata));



-- //@UNDO
-- SQL to undo the change goes here.
DROP SEQUENCE IF EXISTS core.event_server_version_seq;
DROP SEQUENCE IF EXISTS core.client_server_version_seq;
DROP SEQUENCE IF EXISTS core.location_server_version_seq;
DROP SEQUENCE IF EXISTS core.stucture_server_version_seq;
DROP SEQUENCE IF EXISTS core.plan_server_version_seq;
DROP SEQUENCE IF EXISTS core.task_server_version_seq;
DROP SEQUENCE IF EXISTS core.setting_server_version_seq;
DROP SEQUENCE IF EXISTS core.stock_server_version_seq;
DROP SEQUENCE IF EXISTS core.report_server_version_seq;
DROP SEQUENCE IF EXISTS core.view_config_server_version_seq;


