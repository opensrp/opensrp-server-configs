-- // add practitioner and organization sequences
-- Migration SQL that makes the change goes here.
--Create Sequences
CREATE SEQUENCE IF NOT EXISTS team.practitioner_server_version_seq;
CREATE SEQUENCE IF NOT EXISTS team.organization_server_version_seq;

--populate sequences with Max server versions
SELECT setval('team.practitioner_server_version_seq',(SELECT max(server_version )+1 FROM team.practitioner));
SELECT setval('team.organization_server_version_seq',(SELECT max(server_version )+1 FROM team.organization));


-- //@UNDO
-- SQL to undo the change goes here.
DROP SEQUENCE IF EXISTS team.practitioner_server_version_seq;
DROP SEQUENCE IF EXISTS team.organization_server_version_seq;

