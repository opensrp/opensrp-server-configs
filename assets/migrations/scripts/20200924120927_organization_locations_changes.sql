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

-- // organization_locations_changes
-- Migration SQL that makes the change goes here.

DELETE FROM team.organization_location WHERE  to_date < from_date;
ALTER TABLE team.organization_location DROP CONSTRAINT organization_location_organization_id_location_id_plan_id_key ;
ALTER TABLE team.organization_location ADD COLUMN duration daterange;
UPDATE team.organization_location  SET duration=daterange(from_date,to_date);
ALTER TABLE team.organization_location ALTER COLUMN  from_date SET NOT NULL;
ALTER TABLE team.organization_location ALTER COLUMN  duration SET NOT NULL;
CREATE INDEX organization_location_plan_duration_index ON team.organization_location(organization_id, location_id, plan_id, duration);

CREATE EXTENSION IF NOT EXISTS btree_gist SCHEMA team ;

ALTER TABLE team.organization_location ADD CONSTRAINT organization_location_exclusion_key 
 EXCLUDE USING gist (
 organization_id with =,
 location_id with =,
 plan_id with =,
 duration with &&
 );



-- //@UNDO
-- SQL to undo the change goes here.
ALTER TABLE team.organization_location DROP CONSTRAINT organization_location_exclusion_key ;
DROP INDEX team.organization_location_plan_duration_index;
ALTER TABLE team.organization_location DROP COLUMN duration;
ALTER TABLE team.organization_location ADD CONSTRAINT organization_location_organization_id_location_id_plan_id_key UNIQUE (organization_id, location_id, plan_id, from_date);


