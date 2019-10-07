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

-- // create_organization_table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.plan DROP CONSTRAINT IF EXISTS plan_pkey;
ALTER TABLE core.plan RENAME COLUMN id TO identifier;
ALTER TABLE core.plan ADD COLUMN  id bigserial PRIMARY KEY ;
CREATE INDEX plan_identifier_index ON core.plan (identifier);

DROP INDEX IF EXISTS core.plan_id_index;
ALTER TABLE core.plan_metadata RENAME COLUMN plan_id TO identifier;
ALTER TABLE core.plan_metadata ADD COLUMN  plan_id bigserial;
UPDATE core.plan_metadata SET plan_id = (SELECT id FROM core.plan p where p.identifier=core.plan_metadata.identifier);
CREATE INDEX plan_id_index ON core.plan_metadata (plan_id);


-- //@UNDO
-- SQL to undo the change goes here.
ALTER TABLE core.plan DROP CONSTRAINT IF EXISTS plan_pkey;
DROP INDEX IF EXISTS  core.plan_identifier_index;
ALTER TABLE core.plan DROP COLUMN  id;
ALTER TABLE core.plan RENAME COLUMN identifier TO id;
ALTER TABLE core.plan ADD PRIMARY KEY (id);


DROP INDEX IF EXISTS core.plan_id_index;
ALTER TABLE core.plan_metadata DROP COLUMN  plan_id;
ALTER TABLE core.plan_metadata RENAME COLUMN identifier TO plan_id;
CREATE INDEX plan_id_index ON core.plan_metadata (plan_id);
