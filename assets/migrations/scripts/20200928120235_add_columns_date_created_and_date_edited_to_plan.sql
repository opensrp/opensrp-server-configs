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

-- // add_columns_created_at_and_updated_at_to_location_metadata
-- Migration SQL that makes the change goes here.
ALTER TABLE core.plan ADD COLUMN IF NOT EXISTS date_created timestamp DEFAULT NOW();
ALTER TABLE core.plan ADD COLUMN IF NOT EXISTS date_edited timestamp DEFAULT NOW();


-- //@UNDO
-- SQL to undo the change goes here.
ALTER TABLE core.plan DROP COLUMN date_created;
ALTER TABLE core.plan DROP COLUMN date_edited;


