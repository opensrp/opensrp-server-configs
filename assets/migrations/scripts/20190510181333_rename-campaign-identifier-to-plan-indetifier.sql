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

-- // add-plan-indetifier-to-task-metadata
-- Migration SQL that makes the change goes here.

alter table core.task_metadata rename column campaign_identifier to plan_identifier;
update core.task_metadata set plan_identifier=null;


-- //@UNDO
-- SQL to undo the change goes here.
alter table core.task_metadata rename column plan_identifier to campaign_identifier;
update core.task_metadata set campaign_identifier= (select json->>'campaignIdentifier' from core.task where task.id=task_metadata.task_id);


