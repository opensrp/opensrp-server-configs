-- OpenSRP Client ANC Core Client create client detailed view func
create or replace function core.create_core_client_anc_jsonb_flat_view()
    returns text language plpgsql as $$
declare
    cols text;
    attributes_cols text;
    identifiers_cols text;
    final_selected_cols TEXT;
begin
    execute format ($ex$
        select string_agg(format('c."json"->>%%1$L "%%1$s"', key), ', ')
        from (
            select distinct key
            from core."client" c, jsonb_each(c."json")
            order by 1
            ) s;
        $ex$)
    into cols;
    execute format ($ex$
        select string_agg(format('c."json"->''attributes''->>%%1$L "attributes.%%1$s"', key), ', ')
        from (
            select distinct key
            from core."client" c, jsonb_each(c."json" -> 'attributes')
            order by 1
            ) s;
        $ex$)
    into attributes_cols;
    execute format ($ex$
        select string_agg(format('c."json"->''identifiers''->>%%1$L "identifiers.%%1$s"', key), ', ')
        from (
            select distinct key
            from core."client" c, jsonb_each(c."json" -> 'identifiers')
            order by 1
            ) s;
        $ex$)
    into identifiers_cols;
    SELECT concat_ws(', ', cols, identifiers_cols, attributes_cols)
    INTO final_selected_cols;
    execute format($ex$
        drop view if exists core."client_detailed_view";
        create view core."client_detailed_view" as 
        select c.id, date_deleted, server_version,
            %1$s
        from core."client" c
        ORDER BY c."json" ->> 'firstName', c."json" -> 'identifiers' ->> 'ANC_ID', c.id
        $ex$, final_selected_cols);
    return final_selected_cols;
end $$;

SELECT
    core.create_core_client_anc_jsonb_flat_view();
