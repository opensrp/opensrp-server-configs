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

-- // add original file name summary and upload date to multimedia table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.multi_media ADD COLUMN date_uploaded timestamp;
ALTER TABLE core.multi_media ADD COLUMN summary varchar;
ALTER TABLE core.multi_media ADD COLUMN original_file_name varchar;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.multi_media DROP COLUMN date_uploaded;
ALTER TABLE core.multi_media DROP COLUMN summary;
ALTER TABLE core.multi_media DROP COLUMN original_file_name;
