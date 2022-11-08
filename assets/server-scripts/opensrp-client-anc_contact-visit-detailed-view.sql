-- OpenSRP Client ANC Core Event create "Contact Visit" detailed view func
create or replace function core.create_core_event_contact_visit_jsonb_flat_view()
    returns text language plpgsql as $$
declare
    cols text;
    previous_contacts_cols TEXT;
    attention_flag_facts_cols TEXT;
    open_test_tasks_flat_array_cols TEXT;
begin
    execute format ($ex$
        select string_agg(format('e."json"->>%%1$L "%%1$s"', key), ', ')
        from (
            select distinct key
            from core."event" e, jsonb_each(e."json")
            WHERE e."json" ->> 'eventType' = 'Contact Visit'
            order by 1
            ) s;
        $ex$)
    into cols;
    execute format ($ex$
        SELECT REPLACE(%1$L, ', e."json"->>''details'' "details"', '') -- deselect 'details' col
    $ex$, cols)
    INTO cols;
    execute format ($ex$
        select string_agg(format('jsonb_pc."prev_cntcts"->>%%1$L "prev_cntcts.%%1$s"', key), ', ')
        from (
            select distinct key
            from core."event" e,
            jsonb_to_record(e."json" -> 'details') AS details(
                "previous_contacts" text
            ),
            jsonb_each(details."previous_contacts"::jsonb)
            WHERE e."json" ->> 'eventType' = 'Contact Visit'
            order by 1
            ) s;
        $ex$)
    into previous_contacts_cols;
    execute format ($ex$
        select string_agg(format('jsonb_aff."attention_f_facts"->>%%1$L "attention_f_facts.%%1$s"', key), ', ')
        from (
            select distinct key
            from core."event" e,
            jsonb_to_record(e."json" -> 'details') AS details(
                "attention_flag_facts" text
            ),
            jsonb_each(details."attention_flag_facts"::jsonb)
            WHERE e."json" ->> 'eventType' = 'Contact Visit'
            order by 1
            ) s;
        $ex$)
    into attention_flag_facts_cols;
    execute format ($ex$
        select string_agg(format('e_sub.open_test_tasks_flat_array->>%%1$L "%%1$s"', key), ', ')
        from (
            select distinct key
            from core."event" e,
                jsonb_to_record(e."json" -> 'details') AS details(
                    "open_test_tasks" text
                ),
                jsonb_each(
                    core.flat_array(
                        (
                            '{"open_t_tasks": ' || 
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        details."open_test_tasks",
                                        '"{',
                                        '{'
                                    ),
                                    '}"',
                                    '}'
                                ),
                                '\"',
                                '"'
                            )
                            || '}'
                        )::jsonb,
                        'open_t_tasks',
                        'key'
                    )
                )
            WHERE e."json" ->> 'eventType' = 'Contact Visit'
            order by 1
            ) s;
        $ex$)
    into open_test_tasks_flat_array_cols;
    execute format($ex$
        drop view if exists core."event_Contact Visit detailed_view";
        create view core."event_Contact Visit detailed_view" as 
        select e.id, date_deleted, server_version,
            %1$s,  
            details."Contact",
            details."form_submission_ids",
            %2$s,
            %3$s,
            %4$s
        from core."event" e
        LEFT JOIN (
            SELECT
                e2.id "id",
                core.flat_array(
                    (
                        '{"open_t_tasks": ' || 
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    details2."open_test_tasks",
                                    '"{',
                                    '{'
                                ),
                                '}"',
                                '}'
                            ),
                            '\"',
                            '"'
                        )
                        || '}'
                    )::jsonb,
                    'open_t_tasks',
                    'key'
                ) AS open_test_tasks_flat_array
            FROM
                core."event" e2,
                jsonb_to_record(e2."json" -> 'details') AS details2(
                    "open_test_tasks" text
                )
            WHERE
                e2."json" ->> 'eventType' = 'Contact Visit'
        ) e_sub ON e_sub.id = e.id
        CROSS JOIN jsonb_to_record(e."json" -> 'details') AS details(
                "Contact" TEXT,
                "form_submission_ids" TEXT,
                "previous_contacts" TEXT,
                "attention_flag_facts" TEXT
        )
        CROSS JOIN
            jsonb_to_record(('{"attention_f_facts":' || details."attention_flag_facts" || '}')::jsonb
            ) AS jsonb_aff("attention_f_facts" jsonb)
        CROSS JOIN
            jsonb_to_record(('{"prev_cntcts":' || details."previous_contacts" || '}')::jsonb
            ) AS jsonb_pc("prev_cntcts" jsonb)
        WHERE e."json" ->> 'eventType' = 'Contact Visit'
        $ex$, cols, previous_contacts_cols, attention_flag_facts_cols, open_test_tasks_flat_array_cols);
    return cols || previous_contacts_cols || attention_flag_facts_cols || open_test_tasks_flat_array_cols;
end $$;

SELECT
    core.create_core_event_contact_visit_jsonb_flat_view();
