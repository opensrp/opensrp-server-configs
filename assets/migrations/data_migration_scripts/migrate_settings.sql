SET search_path to core;

CREATE OR REPLACE FUNCTION parse_json ()
RETURNS VOID
AS
$$

  DECLARE setting_configurations jsonb;
  DECLARE setting jsonb;
  DECLARE setting_id bigint;

  BEGIN
    FOR setting_id, setting_configurations IN (SELECT id, json from settings)
    LOOP
        FOR setting IN SELECT * FROM jsonb_array_elements((setting_configurations->>'settings')::jsonb)
        LOOP
           RAISE NOTICE 'document_id: %', setting_configurations->>'_id';
           RAISE NOTICE 'setting_id %', setting_id;
           RAISE NOTICE 'identifier: %', setting_configurations->>'identifier';
           RAISE NOTICE 'team: %', setting_configurations->>'team';
           RAISE NOTICE 'team_id: %', setting_configurations->>'teamId';
           RAISE NOTICE 'provider_id: %', setting_configurations->>'providerId';
           RAISE NOTICE 'location_id: %', setting->>'locationId';
           RAISE NOTICE 'setting_key: %', setting->>'key';
           RAISE NOTICE 'setting_value: %', setting->>'value';
           RAISE NOTICE 'setting_description: %', setting->>'description';
           RAISE NOTICE 'setting_type: %', setting->>'type';
           RAISE NOTICE 'uuid: %', setting->>'uuid';
           RAISE NOTICE 'json: %', jsonb_pretty(setting);
        --   INSERT into settings_metadata () VALUES ();
        END LOOP;
    END LOOP;
  END;

$$ LANGUAGE 'plpgsql';

SELECT parse_json();
