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

-- // create migration file table
-- Migration SQL that makes the change goes here.


CREATE TABLE core.client_migration_file
(   
    id bigserial NOT NULL,
    identifier character varying NOT NULL,
    filename character varying NOT NULL,
    on_object_storage BOOLEAN default false,
    object_storage_path character varying,
    jurisdiction character varying,
    version INTEGER NOT NULL,
    manifest_id INTEGER,
    file_contents text,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
) TABLESPACE ${core_tablespace};


CREATE INDEX client_migration_file_filename ON core.client_migration_file(filename);

-- //@UNDO
-- SQL to undo the change goes here.

DROP TABLE IF EXISTS core.client_migration_file;