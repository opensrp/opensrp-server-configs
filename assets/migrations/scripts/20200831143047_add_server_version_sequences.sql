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
CREATE SEQUENCE core.event_server_version_seq;
CREATE SEQUENCE core.client_server_version_seq;
CREATE SEQUENCE core.location_server_version_seq;
CREATE SEQUENCE core.stucture_server_version_seq;
CREATE SEQUENCE core.plan_server_version_seq;
CREATE SEQUENCE core.task_server_version_seq;
CREATE SEQUENCE core.setting_server_version_seq;
CREATE SEQUENCE core.view_config_server_version_seq;



-- //@UNDO
-- SQL to undo the change goes here.
DROP SEQUENCE core.event_server_version_seq;
DROP SEQUENCE core.client_server_version_seq;
DROP SEQUENCE core.location_server_version_seq;
DROP SEQUENCE core.stucture_server_version_seq;
DROP SEQUENCE core.plan_server_version_seq;
DROP SEQUENCE core.task_server_version_seq;
DROP SEQUENCE core.setting_server_version_seq;
DROP SEQUENCE core.view_config_server_version_seq;


