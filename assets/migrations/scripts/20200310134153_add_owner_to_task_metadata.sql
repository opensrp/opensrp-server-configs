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

-- // add owner to task metadata
-- Migration SQL that makes the change goes here.
ALTER TABLE core.task_metadata
    ADD COLUMN IF NOT EXISTS owner VARCHAR;

CREATE INDEX IF NOT EXISTS owner_index
    ON core.task_metadata (owner);

UPDATE core.task_metadata
SET owner = (select json ->> 'owner' from core.task where task.id = task_metadata.task_id);

-- //@UNDO
-- SQL to undo the change goes here.
DROP INDEX IF EXISTS owner_index;

ALTER TABLE core.task_metadata
    DROP COLUMN IF EXISTS owner;
