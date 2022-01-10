-- // add server versions for existing practitioners and organizations
-- Migration SQL that makes the change goes here.


-- Update server version
update team.practitioner set server_version = nextval('team.practitioner_server_version_seq')
where server_version IS NULL;

update team.organization set server_version = nextval('team.organization_server_version_seq')
where server_version IS NULL;


-- //@UNDO
-- SQL to undo the change goes here.

update team.practitioner set server_version = NULL
where server_version IS NOT NULL;

update team.organization set server_version = NULL
where server_version IS NOT NULL;
