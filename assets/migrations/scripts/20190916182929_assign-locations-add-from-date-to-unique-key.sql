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

-- // aassign-locatins-add-from-date-to-unique-key
-- Migration SQL that makes the change goes here.


ALTER TABLE team.organization_location DROP CONSTRAINT organization_location_organization_id_location_id_plan_id_key;
ALTER TABLE  team.organization_location ADD CONSTRAINT organization_location_organization_id_location_id_plan_id_key UNIQUE(organization_id, location_id, plan_id, from_date);

ALTER TABLE team.organization_location ALTER COLUMN from_date TYPE date USING from_date::date;
ALTER TABLE team.organization_location ALTER COLUMN to_date TYPE date USING to_date::date;

-- //@UNDO
-- SQL to undo the change goes here.
ALTER TABLE team.organization_location  DROP CONSTRAINT organization_location_organization_id_location_id_plan_id_key;
ALTER TABLE  team.organization_location ADD CONSTRAINT organization_location_organization_id_location_id_plan_id_key UNIQUE(organization_id, location_id, plan_id);


ALTER TABLE team.organization_location ALTER COLUMN from_date TYPE timestamp USING from_date::timestamp;
ALTER TABLE team.organization_location ALTER COLUMN to_date TYPE timestamp USING to_date::timestamp;



