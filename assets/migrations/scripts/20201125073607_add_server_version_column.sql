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

-- // add_server_version_column
-- Migration SQL that makes the change goes here.
ALTER TABLE core.event ADD COLUMN server_version bigint;
ALTER TABLE core.client ADD COLUMN server_version bigint;
ALTER TABLE core.location ADD COLUMN server_version bigint;
ALTER TABLE core.structure ADD COLUMN server_version bigint;
ALTER TABLE core.task ADD COLUMN server_version bigint;
ALTER TABLE core.report ADD COLUMN server_version bigint;
ALTER TABLE core.settings ADD COLUMN server_version bigint;
ALTER TABLE core.view_configuration ADD COLUMN server_version bigint;


-- //@UNDOnt
-- SQL to undo the change goes here.

ALTER TABLE core.event DROP COLUMN server_version;
ALTER TABLE core.client DROP COLUMN server_version;
ALTER TABLE core.location DROP COLUMN server_version;
ALTER TABLE core.structure DROP COLUMN server_version;
ALTER TABLE core.task DROP COLUMN server_version;
ALTER TABLE core.report DROP COLUMN server_version;
ALTER TABLE core.settings DROP COLUMN server_version;
ALTER TABLE core.view_configuration DROP COLUMN server_version;
