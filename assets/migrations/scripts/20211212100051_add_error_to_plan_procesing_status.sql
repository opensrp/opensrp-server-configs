-- // add error to plan procesing status
-- Migration SQL that makes the change goes here.

ALTER TABLE core.plan_processing_status ADD COLUMN error_log VARCHAR;
comment on column core.plan_processing_status.status is 'initial - 0 | processing - 1 | complete -  2 | failed - 3';

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.plan_processing_status DROP COLUMN error_log;
