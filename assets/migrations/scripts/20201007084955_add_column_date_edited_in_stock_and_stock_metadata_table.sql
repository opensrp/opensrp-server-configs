-- // add column date_edited in stock and stock_metadata table
-- Migration SQL that makes the change goes here.

ALTER TABLE core.stock ADD COLUMN date_deleted timestamp DEFAULT NULL;
ALTER TABLE core.stock_metadata ADD COLUMN IF NOT EXISTS date_deleted timestamp DEFAULT NULL;

CREATE INDEX stock_date_deleted_index ON core.stock (date_deleted);
CREATE INDEX stock_metadata_date_deleted_index ON core.stock_metadata (date_deleted);

-- //@UNDO
-- SQL to undo the change goes here.
DROP INDEX IF EXISTS core.stock_date_deleted_index;
DROP INDEX IF EXISTS core.stock_metadata_date_deleted_index;

ALTER TABLE core.stock DROP COLUMN  date_deleted;
ALTER TABLE core.stock_metadata DROP COLUMN  date_deleted;


