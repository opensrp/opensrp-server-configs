-- // add practitioner and orgs columns date created date edited server version
-- Migration SQL that makes the change goes here.

-- Add date created and date edited columns
ALTER TABLE team.practitioner ADD COLUMN IF NOT EXISTS date_created timestamp DEFAULT NOW();
ALTER TABLE team.practitioner ADD COLUMN IF NOT EXISTS date_edited timestamp DEFAULT NOW();
ALTER TABLE team.organization ADD COLUMN IF NOT EXISTS date_created timestamp DEFAULT NOW();
ALTER TABLE team.organization ADD COLUMN IF NOT EXISTS date_edited timestamp DEFAULT NOW();

-- Add server version columns
ALTER TABLE team.practitioner ADD COLUMN IF NOT EXISTS server_version bigint;
ALTER TABLE team.organization ADD COLUMN IF NOT EXISTS server_version bigint;


-- //@UNDO
-- SQL to undo the change goes here.

ALTER TABLE team.practitioner DROP COLUMN date_created;
ALTER TABLE team.practitioner DROP COLUMN date_edited;
ALTER TABLE team.organization DROP COLUMN date_created;
ALTER TABLE team.organization DROP COLUMN date_edited;

ALTER TABLE team.organization DROP COLUMN server_version;
ALTER TABLE team.organization DROP COLUMN server_version;


