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

-- // location-properties-json-indexes
-- Migration SQL that makes the change goes here.
--Properties JSON Index
CREATE INDEX IF NOT EXISTS location_properties_json_idx ON core.location
USING BTREE ((json->'properties'->>'geographicLevel'),(json->'properties'->>'status'),
(json->'properties'->>'name'),(json->'properties'->>'parentId'));

--Location Id index
CREATE INDEX IF NOT EXISTS  location_metadata_location_id_idx ON core.location_metadata(location_id);

--Parent Id index
CREATE INDEX IF NOT EXISTS  location_metadata_parent_status_idx ON core.location_metadata(parent_id,status);


-- //@UNDO
-- SQL to undo the change goes here.
DROP INDEX IF EXISTS  core.location_properties_json_idx;
DROP INDEX IF EXISTS  core.location_metadata_location_id_idx;
DROP INDEX IF EXISTS  core.location_metadata_parent_status_idx;

