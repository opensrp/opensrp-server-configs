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

-- // add server version indexes
-- Migration SQL that makes the change goes here.

CREATE INDEX event_metadata_server_version_index ON core.event_metadata(server_version);

CREATE INDEX location_metadata_server_version_index ON core.location_metadata(server_version);

CREATE INDEX structure_metadata_server_version_index ON core.structure_metadata(server_version);

CREATE INDEX task_metadata_server_version_index ON core.task_metadata(server_version);

-- //@UNDO
-- SQL to undo the change goes here.

DROP INDEX core.event_metadata_server_version_index;

DROP INDEX core.location_metadata_server_version_index;

DROP INDEX  core.structure_metadata_server_version_index;

DROP INDEX  core.task_metadata_server_version_index;