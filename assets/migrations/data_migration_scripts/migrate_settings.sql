SET search_path to core;

CREATE OR REPLACE FUNCTION parse_json ()
RETURNS VOID
AS
$$
  DECLARE setting_configurations jsonb;
  DECLARE setting jsonb;
  BEGIN
    SELECT json from settings into setting_configurations;
    RAISE NOTICE 'Parsing setting configuration %', setting_configurations->>'_id';
    FOR setting IN SELECT * FROM jsonb_array_elements((setting_configurations->>'settings')::jsonb)
    LOOP
       RAISE NOTICE 'Parsing setting % - %', setting->>'key', setting->>'label';
    END LOOP;
  END;
$$ LANGUAGE 'plpgsql';

SELECT parse_json();
