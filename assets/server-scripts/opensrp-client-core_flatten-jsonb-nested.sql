-- Generalized solution (for jsonb) https://stackoverflow.com/a/35179515
create or replace function core.create_jsonb_nested_flat_view
    (table_name text, regular_columns text, json_column TEXT, VARIADIC json_nested_columns TEXT[] DEFAULT '{}')
    returns text language plpgsql as $$
declare
    cols text;
    nested_cols TEXT;
    nested_col TEXT;
    temp_nested_cols text;
    final_selected_cols TEXT;
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
    FOREACH nested_col IN ARRAY json_nested_columns
    LOOP
        execute format ($ex$
        select string_agg(format('%2$s -> ''%3$s'' ->> %%1$L "%3$s.%%1$s"', key), ', ')
        from (
            select distinct key
            from core.%1$s, jsonb_each(%2$s -> %3$L)
            order by 1
            ) s;
        $ex$, table_name, json_column, nested_col)
        into temp_nested_cols;
        SELECT concat_ws(', ', nested_cols, temp_nested_cols)
        INTO nested_cols;
        execute format ($ex$
            SELECT REPLACE(%3$L, ', %2$s->>''%1$s'' "%1$s"', '')
        $ex$, nested_col, json_column, cols)
        INTO cols;
    END LOOP;
    SELECT concat_ws(', ', cols, nested_cols)
    INTO final_selected_cols;
    execute format($ex$
        drop view if exists core.%1$s_detailed_view;
        create view core.%1$s_detailed_view as 
        select %2$s, %3$s from core.%1$s a
        $ex$, table_name, regular_columns, final_selected_cols);
    return final_selected_cols;
end $$;

-- Sample usage, with nested json object(s) `identifiers` and `attributes`
SELECT
	core.create_jsonb_nested_flat_view(
	   'client',
	   'id, date_deleted, server_version',
	   'json',
       'identifiers', 'attributes'
	);
