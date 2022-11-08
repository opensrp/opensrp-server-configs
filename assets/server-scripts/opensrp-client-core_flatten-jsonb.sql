-- Specific logic hidden in the arrays https://stackoverflow.com/a/54290549
create or replace function core.flat_array(data jsonb, title text, item text)
returns jsonb language sql immutable as $$
    select jsonb_object_agg(format('%s.%s.%s', title, elem->>item, key), value)
    from jsonb_array_elements(data->title) as arr(elem)
    cross join jsonb_each(elem)
    where key <> item
$$;



-- Generalized solution (for jsonb) https://stackoverflow.com/a/35179515
create or replace function core.create_jsonb_flat_view
    (table_name text, regular_columns text, json_column text)
    returns text language plpgsql as $$
declare
    cols text;
begin
    execute format ($ex$
        select string_agg(format('%2$s->>%%1$L "%%1$s"', key), ', ')
        from (
            select distinct key
            from core.%1$s, jsonb_each(%2$s)
            order by 1
            ) s;
        $ex$, table_name, json_column)
    into cols;
    execute format($ex$
        drop view if exists core.%1$s_view;
        create view core.%1$s_view as 
        select %2$s, %3$s from core.%1$s a
        $ex$, table_name, regular_columns, cols);
    return cols;
end $$;

SELECT
	core.create_jsonb_flat_view('client',
	'id, date_deleted, server_version',
	'json'),
	core.create_jsonb_flat_view('event',
	'id, date_deleted, server_version',
	'json');



-- OpenSRP Core Event create view func
create or replace function core.create_core_event_jsonb_flat_view
    (table_name text, regular_columns text, json_column text, event_type text)
    returns text language plpgsql as $$
declare
    cols text;
    flat_obs_cols text;
begin
    execute format ($ex$
        select string_agg(format('%2$s->>%%1$L "%%1$s"', key), ', ')
        from (
            select distinct key
            from core.%1$s e, jsonb_each(%2$s)
            WHERE e.%2$s ->> 'eventType' = %3$L
            order by 1
            ) s;
        $ex$, table_name, json_column, event_type)
    into cols;
    execute format ($ex$
        select string_agg(format('e_sub.obs_flat_array->>%%1$L "%%1$s"', key), ', ')
        from (
            select distinct key
            from core.%1$s e, jsonb_each(core.flat_array(e.%2$s,
                'obs',
                'formSubmissionField'))
            WHERE e.%2$s ->> 'eventType' = %3$L
            order by 1
            ) s;
        $ex$, table_name, json_column, event_type)
    into flat_obs_cols;
    IF flat_obs_cols IS NULL THEN
        execute format($ex$
            drop view if exists core."%1$s_%5$s_view";
            create view core."%1$s_%5$s_view" as 
            select %2$s, %3$s from core.%1$s e
            WHERE e.%4$s ->> 'eventType' = %5$L
            $ex$, table_name, regular_columns, cols, json_column, event_type);
    ELSE
        execute format ($ex$
            SELECT REPLACE(%1$L, ', %2$s->>''obs'' "obs"', '') -- deselect 'obs' col
        $ex$, cols, json_column)
        INTO cols;
        execute format($ex$
            drop view if exists core."%1$s_%5$s_view";
            create view core."%1$s_%5$s_view" as 
            select %2$s, %3$s, %6$s from core.%1$s e
            LEFT JOIN (SELECT
                e2.id,
                core.flat_array(e2.%4$s,
                'obs',
                'formSubmissionField') AS obs_flat_array
                FROM
                    core.%1$s e2
                WHERE
                    e2.%4$s ->> 'eventType' = %5$L) e_sub ON e_sub.id = e.id
            WHERE e.%4$s ->> 'eventType' = %5$L
            $ex$, table_name, regular_columns, cols, json_column, event_type, flat_obs_cols);
    END IF;
    return cols || flat_obs_cols;
end $$;



-- OpenSRP Core Event generate all event type views
create or replace function core.generate_all_event_type_views()
    returns text language plpgsql as $$
declare
    the_queries text;
begin
    execute format ($ex$
        select
            string_agg(
                format('core.create_core_event_jsonb_flat_view(''event'',''e.id, date_deleted, server_version'',''json'',%%1$L)', "eventType"),
                ', '
            )
        from (
            SELECT
                DISTINCT e."json" ->> 'eventType' AS "eventType"
            FROM
                core."event" e
            ORDER BY
                1
            ) s;
        $ex$)
    into the_queries;
    execute format($ex$
        select %1$s
        $ex$, the_queries);
    return the_queries;
end $$;

SELECT
    core.generate_all_event_type_views();
