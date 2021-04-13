-- // create sms api processing status table
-- Migration SQL that makes the change goes here.

CREATE TABLE core.sms_api_processing_status
(
  id bigserial NOT NULL,
  base_entity_id character varying NOT NULL,
  event_type character varying NOT NULL,
  service_type character varying NOT NULL,
  request_status character varying NOT NULL,
  request_id character varying UNIQUE NOT NULL,
  date_created timestamp,
  last_updated timestamp,
  sms_delivery_status character varying,
  attempts int NOT NULL,
  sms_delivery_date timestamp,
  PRIMARY KEY (id)
)
WITH (
  OIDS = FALSE
) TABLESPACE ${core_tablespace};

CREATE INDEX sms_api_processing_status_request_id_index ON core.sms_api_processing_status (request_id);

-- //@UNDO
-- SQL to undo the change goes here.


DROP TABLE core.sms_api_processing_status;
