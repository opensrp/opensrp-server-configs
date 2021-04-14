-- // add request_id to sms api processing status table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.sms_api_processing_status ADD COLUMN IF NOT EXISTS request_id VARCHAR;

-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE core.sms_api_processing_status DROP COLUMN request_id;
