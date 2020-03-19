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

-- // create table client_form_metadata
-- Migration SQL that makes the change goes here.
CREATE TABLE core.client_form_metadata
(
    id INTEGER REFERENCES core.client_form(id),
    identifier character varying NOT NULL,
    jurisdiction character varying,
    version character varying NOT NULL,
    label character varying(200) NOT NULL,
    module character varying(200),
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)

CREATE INDEX client_form_metadata_identifier ON core.client_form_metadata(identifier);
CREATE INDEX client_form_metadata_version ON core.client_form_metadata(version);


-- //@UNDO
-- SQL to undo the change goes here.
DROP TABLE core.client_form_metadata


