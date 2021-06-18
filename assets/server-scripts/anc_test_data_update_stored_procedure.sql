CREATE OR REPLACE FUNCTION update_dates(countParam numeric)
    RETURNS void AS
$$
Declare
    counter                     varchar := CAST(countParam AS text) || 'Month'; -- number of months that needs to be added in all the dates objects.
    eventRecord                 core.event%ROWTYPE;
    clientRecord                core.client%ROWTYPE;
    iso8601dateTimeFormat       text    := 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"';
    obs                         jsonb;
    photo                       jsonb;
    address                     jsonb;
    obsValues                   varchar;
    contactPoint                jsonb;
    statusHistoryRecord         record;
    attributeRecord             record;
    eventDateCreated            timestamptz;
    eventDateCreatedString      varchar;
    eventDateEdited             timestamptz;
    eventDateEditedString       varchar;
    clientDateCreated           timestamptz;
    clientDateCreatedString     varchar;
    clientDateEdited            timestamptz;
    clientDateEditedString      varchar;
    eventDateVoided             timestamptz;
    eventDateVoidedString       varchar;
    eventDate                   timestamptz;
    eventDateString             varchar;
    obsEffectiveDatetime        timestamptz;
    obsEffectiveDatetimeString  varchar;
    photoDateCreated            timestamptz;
    photoDateCreatedString      varchar;
    clientServerVersion         bigint;
    clientServerVersionString   varchar;
    eventServerVersion          bigint;
    eventServerVersionString    varchar;
    addressStartDate            timestamptz;
    addressStartDateString      varchar;
    addressEndDate              timestamptz;
    addressEndDateString        varchar;
    contactPointStartDate       timestamptz;
    contactPointStartDateString varchar;
    contactPointEndDate         timestamptz;
    contactPointEndDateString   varchar;
    obsValue                    timestamptz;
    obsValueString              varchar;
    attributeValue              timestamptz;
    attributeValueString        varchar;
    statusHistoryValue          timestamptz;
    statusHistoryValueString    varchar;
    i                           integer := 0;
    j                           integer := 0;
    loopCounter                 varchar;
    valuesLoopCounter           varchar;
BEGIN

    --  Start Event records update
    FOR eventRecord IN
        SELECT *
        FROM core.event e
        LOOP
            RAISE NOTICE 'Event is : %', eventRecord.id;

            --  Update Event json ->> dateCreated
            IF ((eventRecord.json ->> 'dateCreated') is not null) and (eventRecord.json ->> 'dateCreated' != '')
            THEN
                eventDateCreated := ((eventRecord.json ->> 'dateCreated'):: timestamptz) + CAST(counter as interval);
                eventDateCreatedString := to_char(eventDateCreated, iso8601dateTimeFormat);

                update core.event
                set json = jsonb_set(json, '{dateCreated}', concat('"', eventDateCreatedString, '"')::jsonb)
                where id = eventRecord.id;
            END IF;
            --

            --  Update Event json ->> dateEdited
            IF ((eventRecord.json ->> 'dateEdited') is not null) and (eventRecord.json ->> 'dateEdited' != '')
            THEN
                --  RAISE NOTICE 'Updating dateEdited in Event json : %', eventRecord.id;
                eventDateEdited := ((eventRecord.json ->> 'dateEdited'):: timestamptz) + CAST(counter as interval);
                eventDateEditedString := to_char(eventDateEdited, iso8601dateTimeFormat);

                update core.event
                set json = jsonb_set(json, '{dateEdited}', concat('"', eventDateEditedString, '"')::jsonb)
                where id = eventRecord.id;
            END IF;
            --

            --  Update Event json ->> dateVoided
            IF ((eventRecord.json ->> 'dateVoided') is not null) and (eventRecord.json ->> 'dateVoided' != '')
            THEN
                eventDateVoided := ((eventRecord.json ->> 'dateVoided'):: timestamptz) + CAST(counter as interval);
                eventDateVoidedString := to_char(eventDateVoided, iso8601dateTimeFormat);

                update core.event
                set json = jsonb_set(json, '{dateVoided}', concat('"', eventDateVoidedString, '"')::jsonb)
                where id = eventRecord.id;

            END IF;
            --

            --  Update Event json ->> eventDate
            IF ((eventRecord.json ->> 'eventDate') is not null) and (eventRecord.json ->> 'eventDate' != '')
            THEN
                eventDate := ((eventRecord.json ->> 'eventDate'):: timestamptz) + CAST(counter as interval);
                eventDateString := to_char(eventDate, iso8601dateTimeFormat);

                update core.event
                set json = jsonb_set(json, '{eventDate}', concat('"', eventDateString, '"')::jsonb)
                where id = eventRecord.id;

            END IF;
            --

            --  Update Event json ->> serverVersion
            IF ((eventRecord.json ->> 'serverVersion') is not null) and (eventRecord.json ->> 'serverVersion' != '')
            THEN
                eventServerVersion := extract(epoch from (
                        to_timestamp((eventRecord.json ->> 'serverVersion'):: bigint / 1000) +
                        CAST(counter as interval))) *
                                      1000;
                eventServerVersionString := eventServerVersion::text;

                update core.event
                set json = jsonb_set(json, '{serverVersion}', eventServerVersionString::jsonb)
                where id = eventRecord.id;

            END IF;
            --

            --  Update Event json ->> obs
            --  RAISE NOTICE 'eventRecord is %', eventRecord.id;
            i := 0;
            IF ((eventRecord.json ->> 'obs') is not null)
            THEN
                RAISE NOTICE 'Inside inner loop for obs';
                FOR obs IN select jsonb_array_elements(eventRecord.json -> 'obs')
                    LOOP
                        --RAISE NOTICE 'Obs is% and event id is %',obs,eventRecord.id;
                        loopCounter := CAST(i AS text);
                        RAISE NOTICE 'i = Obs loop is %', loopCounter;
                        RAISE NOTICE 'Checking for effectiveDateTime when obs[ % ]',loopCounter;
                        IF ((obs -> 'effectiveDatetime') is not null)
                        THEN
                            RAISE NOTICE 'Effective date time is% and event id is %,Obs [ % ]',obs -> 'effectiveDateTime',eventRecord.id,loopCounter;
                            obsEffectiveDatetime :=
                                    ((obs ->> 'effectiveDatetime'):: timestamp) + CAST(counter as interval);
                            obsEffectiveDatetimeString := obsEffectiveDatetime::text;

                            RAISE NOTICE 'Updating path {obs, % ,effectiveDatetime} with the value of %' , loopCounter,obsEffectiveDatetimeString;
                            update core.event
                            set json = jsonb_set(json, concat('{obs,', loopCounter, ',effectiveDatetime}')::text[],
                                                 concat('"', obsEffectiveDatetimeString, '"')::jsonb)
                            where id = eventRecord.id;
                        END IF;
                        --

                        --  Update Event obs ->> values
                        IF ((obs -> 'values') is not null)
                            --  RAISE NOTICE 'Obs is% and event id is %',obs,eventRecord.id;
                        THEN
                            j := 0;
                            FOR obsValues IN select jsonb_array_elements(obs -> 'values')
                                LOOP
                                    valuesLoopCounter := CAST(j AS text);
                                    RAISE NOTICE 'j = Values loop is %', valuesLoopCounter;
                                    RAISE NOTICE 'Checking for obsValue % when obs[ % ] and values[ % ]', obsValues,loopCounter,valuesLoopCounter;
                                    IF ((obsValues is not null) and (select is_date(obsValues ::varchar)))
                                    THEN
                                        RAISE NOTICE 'Obs value is % and event id is %, values[ % ], outer Loop Obs[ % ]', obsValues,eventRecord.id,valuesLoopCounter,loopCounter;
                                        IF (select check_date_format(obsValues))
                                        THEN
                                            RAISE NOTICE 'Inside if block check_date_format successful';
                                            obsValue := (obsValues:: timestamp) + CAST(counter as interval);
                                            obsValueString := obsValue::text;
                                        ELSE
                                            RAISE NOTICE 'Inside else block check_date_format not successful';

                                            obsValueString :=
                                                    (select to_char((select to_char((select TO_DATE(
                                                                                                    trim(both '"' from obsValues),
                                                                                                    'DD-MM-YYYY')),
                                                                                    'YYYY-MM-DD')::timestamp +
                                                                            CAST(counter as interval))::date,
                                                                    'DD-MM-YYYY'));

                                            RAISE NOTICE 'ObsValue computed successfully';
                                        END IF;
                                        RAISE NOTICE 'Updating path {obs, % ,values, %} with the value of %' , loopCounter, valuesLoopCounter,obsValueString;
                                        update core.event
                                        set json = jsonb_set(json,
                                                             concat('{obs,', loopCounter, ',values,', valuesLoopCounter, '}')::text[],
                                                             concat('"', obsValueString, '"')::jsonb)
                                        where id = eventRecord.id;

                                    END IF;
                                    j := j + 1;
                                END LOOP;
                        END IF;

                        i := i + 1;
                    END LOOP;
            END IF;
            --

            --  Update event json ->> statusHistory
            i := 0;
            IF ((eventRecord.json ->> 'statusHistory') is not null)
            THEN
                FOR statusHistoryRecord IN SELECT * FROM jsonb_each_text(eventRecord.json -> 'statusHistory')
                    LOOP
                        RAISE NOTICE 'key %', statusHistoryRecord.key;
                        RAISE NOTICE 'value %', statusHistoryRecord.value;

                        IF ((statusHistoryRecord.value is not null) and
                            (select is_date(statusHistoryRecord.value ::varchar)))
                        THEN
                            RAISE NOTICE 'status History record value is% and event id is %', statusHistoryRecord.value,eventRecord.id;
                            IF (select check_date_format(obsValues))
                            THEN
                                RAISE NOTICE 'Inside if block check_date_format successful in status history';
                                statusHistoryValue :=
                                        (statusHistoryRecord.value:: timestamp) + CAST(counter as interval);
                                statusHistoryValueString := statusHistoryValue::text;
                            ELSE
                                RAISE NOTICE 'inside else block of status history';
                                RAISE NOTICE 'ELSE BLOCK STATUS HISTORY : %', (select to_char((select to_char(
                                                                                                              (select TO_DATE(
                                                                                                                              trim(both '"' from statusHistoryRecord.value),
                                                                                                                              'DD-MM-YYYY')),
                                                                                                              'YYYY-MM-DD')::timestamp +
                                                                                                      CAST(counter as interval))::date,
                                                                                              'DD-MM-YYYY'));

                                statusHistoryValueString :=
                                        (select to_char((select to_char((select TO_DATE(
                                                                                        trim(both '"' from statusHistoryRecord.value),
                                                                                        'DD-MM-YYYY')),
                                                                        'YYYY-MM-DD')::timestamp +
                                                                CAST(counter as interval))::date, 'DD-MM-YYYY'));

                                RAISE NOTICE 'statusHistoryRecord.value computed successfully';
                            END IF;
                            RAISE NOTICE 'Updating path {statusHistory, % } with the value of % and event id is %' , statusHistoryRecord.key,statusHistoryValueString,eventRecord.id;
                            update core.event
                            set json = jsonb_set(json, concat('{statusHistory,', statusHistoryRecord.key, '}')::text[],
                                                 concat('"', statusHistoryValueString, '"')::jsonb)
                            where id = eventRecord.id;

                        END IF;

                        i := i + 1;
                    END LOOP;
            END IF;
            --

            --  Update event json ->> details
            IF ((eventRecord.json ->> 'details') is not null)
            THEN
                update core.event
                set json = jsonb_set(json, '{details}'::text[],
                                     (select update_event_details((json -> 'details'), counter::text))::jsonb)
                where id = eventRecord.id;
            END IF;
            --

            --  Update event json photos (dateCreated)
            i := 0;
            IF ((eventRecord.json ->> 'photos') is not null)
            THEN
                --  RAISE NOTICE 'Inside inner loop for photos';
                FOR photo IN select jsonb_array_elements(eventRecord.json -> 'photos')
                    LOOP
                        RAISE NOTICE 'Photos is % and event id is %',photo,eventRecord.id;
                        loopCounter := CAST(i AS text);
                        IF ((photo ->> 'dateCreated') is not null)
                        THEN
                            RAISE NOTICE 'Photo is is% and event id is %',photo,eventRecord.id;
                            IF (select check_date_format(photo ->> 'dateCreated'))
                            THEN
                                photoDateCreated := ((photo ->> 'dateCreated'):: timestamp) + CAST(counter as interval);
                                photoDateCreatedString := photoDateCreated::text;
                            ELSE
                                photoDateCreatedString :=
                                        (select to_char((select to_char((select TO_DATE(
                                                                                        trim(both '"' from photo ->> 'dateCreated'),
                                                                                        'DD-MM-YYYY')),
                                                                        'YYYY-MM-DD')::timestamp +
                                                                CAST(counter as interval))::date, 'DD-MM-YYYY'));

                            END IF;
                            update core.event
                            set json = jsonb_set(json, concat('{photos,', loopCounter, ',dateCreated}')::text[],
                                                 concat('"', photoDateCreatedString, '"')::jsonb)
                            where id = eventRecord.id;
                        END IF;
                        i := i + 1;
                    END LOOP;
            END IF;
        END LOOP;
    --

    --  Update Event dateDeleted
    UPDATE core.event
    SET date_deleted = date_deleted + CAST(counter as interval);
    --

    --  Update Event serverVersion
    UPDATE core.event
    SET server_version = extract(epoch from (
        to_timestamp(server_version) + CAST(counter as interval)));
    --

    --  Update Event Metadata eventDate
    UPDATE core.event_metadata
    SET event_date = event_date + CAST(counter as interval);
    --

    --  Update Event Metadata dateCreated
    UPDATE core.event_metadata
    SET date_created = date_created + CAST(counter as interval);
    --

    --  Update Event Metadata dateEdited
    UPDATE core.event_metadata
    SET date_edited = date_edited + CAST(counter as interval);
    --

    --  Update Event Metadata dateDeleted
    UPDATE core.event_metadata
    SET date_deleted = date_deleted + CAST(counter as interval);
    --

    --  Update Event Metadata serverVersion
    UPDATE core.event_metadata
    SET server_version = extract(epoch from (
            to_timestamp(server_version / 1000 :: bigint) + CAST(counter as interval))) * 1000;
    --

-- Start Client Records Update
    FOR clientRecord IN
        SELECT *
        FROM core.client client
        LOOP
            RAISE NOTICE 'Client is : %', clientRecord.id;

            --  Update client json ->> dateCreated
            IF ((clientRecord.json ->> 'dateCreated') is not null) and (clientRecord.json ->> 'dateCreated' != '')
            THEN
                clientDateCreated := ((clientRecord.json ->> 'dateCreated'):: timestamptz) + CAST(counter as interval);
                clientDateCreatedString := to_char(clientDateCreated, iso8601dateTimeFormat);

                update core.client
                set json = jsonb_set(json, '{dateCreated}', concat('"', clientDateCreatedString, '"')::jsonb)
                where id = clientRecord.id;

            END IF;
            --

            --  Update client json ->> dateEdited
            IF ((clientRecord.json ->> 'dateEdited') is not null) and (clientRecord.json ->> 'dateEdited' != '')
            THEN
                --RAISE NOTICE 'Updating dateEdited in Client json : %', clientRecord.id;
                clientDateEdited := ((clientRecord.json ->> 'dateEdited'):: timestamptz) + CAST(counter as interval);
                clientDateEditedString := to_char(clientDateEdited, iso8601dateTimeFormat);
                update core.client
                set json = jsonb_set(json, '{dateEdited}', concat('"', clientDateEditedString, '"')::jsonb)
                where id = clientRecord.id;
            END IF;
            --

            --  Update client json ->> serverVersion
            IF ((clientRecord.json ->> 'serverVersion') is not null) and (clientRecord.json ->> 'serverVersion' != '')
            THEN
                clientServerVersion := extract(epoch from (
                        to_timestamp((clientRecord.json ->> 'serverVersion'):: bigint / 1000) +
                        CAST(counter as interval))) *
                                       1000;
                clientServerVersionString := clientServerVersion::text;

                update core.client
                set json = jsonb_set(json, '{serverVersion}', clientServerVersionString::jsonb)
                where id = clientRecord.id;

            END IF;
            --

            --  Update client json ->> addresses
            i := 0;
            IF (clientRecord.json -> 'addresses' is not null)
            THEN
                RAISE NOTICE 'Inside inner loop for addresses';
                FOR address IN select jsonb_array_elements(clientRecord.json -> 'addresses')
                    LOOP
                        RAISE NOTICE 'Address is% and client id is %',address,clientRecord.id;
                        loopCounter := CAST(i AS text);
                        IF ((address ->> 'startDate') is not null)
                        THEN
                            addressStartDate := ((address ->> 'startDate'):: timestamp) + CAST(counter as interval);
                            addressStartDateString := addressStartDate::text;

                            RAISE NOTICE 'updating address ---- {addresses, % ,startDate} where client id is % and addressstartdateString is : %', loopCounter, clientRecord.id, addressStartDateString;
                            update core.client
                            set json = jsonb_set(json, concat('{addresses,', loopCounter, ',startDate}')::text[],
                                                 concat('"', addressStartDateString, '"')::jsonb)
                            where id = clientRecord.id;
                        END IF;

                        IF ((address ->> 'endDate') is not null)
                        THEN
                            addressEndDate := ((address ->> 'endDate'):: timestamp) + CAST(counter as interval);
                            addressEndDateString := addressEndDate::text;

                            update core.client
                            set json = jsonb_set(json, concat('{addresses,', loopCounter, ',endDate}')::text[],
                                                 concat('"', addressEndDateString, '"')::jsonb)
                            where id = clientRecord.id;
                        END IF;

                        i := i + 1;
                    END LOOP;
            END IF;
            --

            --  Update client json ->> contactPoints
            i := 0;
            IF (clientRecord.json ->> 'contactPoints' is not null)
            THEN
                RAISE NOTICE 'Inside inner loop for contactPoints';
                FOR contactPoint IN select jsonb_array_elements(clientRecord.json -> 'contactPoints')
                    LOOP
                        RAISE NOTICE 'contactPoint is% and client id is %',contactPoint,clientRecord.id;
                        loopCounter := CAST(i AS text);
                        IF ((contactPoint ->> 'startDate') is not null)
                        THEN
                            contactPointStartDate :=
                                        ((contactPoint ->> 'startDate'):: timestamp) + CAST(counter as interval);
                            contactPointStartDateString := contactPointStartDate::text;

                            RAISE NOTICE 'updating contactPoints, % ,startDate} where clientRecord id is : % and string updated value is : %', loopCounter, clientRecord.id, contactPointStartDateString;
                            update core.client
                            set json = jsonb_set(json, concat('{contactPoints,', loopCounter, ',startDate}')::text[],
                                                 concat('"', contactPointStartDateString, '"')::jsonb)
                            where id = clientRecord.id;
                        END IF;

                        IF ((contactPoint -> 'endDate') is not null)
                        THEN
                            contactPointEndDate :=
                                    ((contactPoint ->> 'endDate'):: timestamp) + CAST(counter as interval);
                            contactPointEndDateString := contactPointEndDate::text;

                            update core.client
                            set json = jsonb_set(json, concat('{contactPoints,', loopCounter, ',endDate}')::text[],
                                                 concat('"', contactPointEndDateString, '"')::jsonb)
                            where id = clientRecord.id;
                        END IF;

                        i := i + 1;
                    END LOOP;
            END IF;
            --

            --  Update client json ->> photos
            i := 0;
            IF ((clientRecord.json ->> 'photos') is not null)
            THEN
                --RAISE NOTICE 'Inside inner loop for photos';
                FOR photo IN select jsonb_array_elements(clientRecord.json -> 'photos')
                    LOOP
                        --RAISE NOTICE 'Photos is % and event id is %',photo,clientRecord.id;
                        loopCounter := CAST(i AS text);
                        IF ((photo ->> 'dateCreated') is not null)
                        THEN
                            --RAISE NOTICE 'Photo is is% and event id is %',photo,eventRecord.id;
                            photoDateCreated := ((photo ->> 'dateCreated'):: timestamp) + CAST(counter as interval);
                            photoDateCreatedString := photoDateCreated::text;

                            update core.client
                            set json = jsonb_set(json, concat('{photos,', loopCounter, ',dateCreated}')::text[],
                                                 concat('"', photoDateCreatedString, '"')::jsonb)
                            where id = clientRecord.id;
                        END IF;
                        i := i + 1;
                    END LOOP;
            END IF;
            --

            --  Update client json ->> attributes
            IF ((clientRecord.json ->> 'attributes') is not null)
            THEN
                update core.client
                set json = jsonb_set(json, '{attributes}'::text[],
                                     (select update_dates_on_key_value_pair((json -> 'attributes'),
                                                                            counter::text))::jsonb)
                where id = clientRecord.id;
            END IF;
            --

        END LOOP;
    --

    --  Update Client dateDeleted
    UPDATE core.client
    SET date_deleted = date_deleted + CAST(counter as interval);
    --

    --  Update Client serverVersion
    UPDATE core.client
    SET server_version = extract(epoch from (
            to_timestamp(server_version / 1000 :: bigint) + CAST(counter as interval))) * 1000;
    --

    -- Update Client Metadata birthDate
    UPDATE core.client_metadata
    SET birth_date = birth_date + CAST(counter as interval);
    --

    -- Update Client Metadata dateDeleted
    UPDATE core.client_metadata
    SET date_deleted = date_deleted + CAST(counter as interval);
    --

    -- Update Client Metadata dateCreated
    UPDATE core.client_metadata
    SET date_created = date_created + CAST(counter as interval);
    --

    -- Update Client Metadata dateEdited
    UPDATE core.client_metadata
    SET date_edited = date_edited + CAST(counter as interval);
    --

    -- Update Client Metadata serverVersion
    UPDATE core.client_metadata
    SET server_version = extract(epoch from (
            to_timestamp(server_version / 1000 :: bigint) + CAST(counter as interval))) * 1000;
    --
END;
$$
    LANGUAGE plpgsql;

create or replace function is_date(dateString varchar) returns boolean as
$$
declare
    _dateString varchar := trim(both '"' from dateString);
begin
    RAISE NOTICE 'date is % ', dateString;
    RAISE NOTICE 'checking if condition of date, AFTER TRIMMING %' , _dateString;
    IF (dateString is not null)
        and (_dateString ~ '^\[?[0-9]{2}-[0-9]{2}-[0-9]{4}[TZtz0-9+.:\s]*\]?$'
            or _dateString ~ '^\[?[0-9]{4}-[0-9]{2}-[0-9]{2}[TZtz0-9+.:\s]*\]?$')
    THEN
        RAISE NOTICE 'inside if block of date';
        perform dateString::date;
        return true;
    END IF;
    return false;
exception
    when others then
        RAISE NOTICE 'inside exception block';
        return false;
end;
$$ language plpgsql;

create or replace function check_date_format(dateString varchar) returns boolean as
$$
begin
    RAISE NOTICE 'date is % ', dateString;
    RAISE NOTICE 'checking if condition of date, AFTER TRIMMING %' , trim(both '"' from dateString);
    IF (trim(both '"' from dateString) ~ '[0-9]{4}-[0-9]{2}-[0-9]{2}')
    THEN
        RAISE NOTICE 'inside if block of date format checker';
        return true;
    END IF;
    return false;
exception
    when others then
        RAISE NOTICE 'inside exception block of date format checker';
        return false;
end;
$$ language plpgsql;

create or replace function update_event_details(keyValuePair jsonb, counter text) returns text as
$$
DECLARE
    _key                text;
    _value              text;
    currentDateString   text;
    newDateString       text;
    record              record;
    enclosedWithBracket bool;
BEGIN
    FOR _key,_value IN SELECT * FROM jsonb_each_text(keyValuePair)
        LOOP
            IF (_key != 'open_test_tasks' and _key != 'form_submission_ids' and _key != 'Contact')
            THEN
                IF (select is_valid_json(_value))
                THEN
                    FOR record IN SELECT * FROM jsonb_each_text(_value::jsonb)
                        LOOP
                            IF (record.key != 'attention_flag_facts')
                            THEN
                                IF (select is_date(record.value))
                                THEN
                                    currentDateString = record.value;
                                    enclosedWithBracket = currentDateString ~ '\[.*?\]';
                                    IF (select check_date_format(currentDateString))
                                    THEN
                                        newDateString :=
                                                (select to_char(((trim(both '[]' from currentDateString):: timestamp) +
                                                                 CAST(counter as interval))::timestamp,
                                                                'YYYY-MM-DD'));
                                    ELSE
                                        newDateString :=
                                                (select to_char((select to_char((select TO_DATE(
                                                                                                trim(both '[]' from currentDateString),
                                                                                                'DD-MM-YYYY')::timestamp),
                                                                                'YYYY-MM-DD')::timestamp +
                                                                        CAST(counter as interval))::date,
                                                                'DD-MM-YYYY'));

                                    END IF;
                                    RAISE NOTICE '% is date, new date %', record.key, newDateString;
                                    _value = jsonb_set(_value::jsonb, concat('{', record.key, '}')::text[],
                                                       (case
                                                            when enclosedWithBracket
                                                                then concat('"[', newDateString, ']"')
                                                            else concat('"', newDateString, '"') end)::jsonb);
                                ELSE
                                    RAISE WARNING '% is not date, value %', record.key, record.value;
                                END IF;
                            ELSE
                                _value = jsonb_set(_value::jsonb, concat('{', record.key, '}')::text[],
                                                   to_jsonb(
                                                           (select update_dates_on_key_value_pair(record.value::jsonb, counter))));
                            END IF;
                        END LOOP;
                    keyValuePair = jsonb_set(keyValuePair, concat('{', _key, '}')::text[],
                                             to_jsonb(_value::text));
                END IF;
            END IF;
        END LOOP;
    RETURN keyValuePair;
END ;
$$ language plpgsql;

create or replace function update_dates_on_key_value_pair(keyValuePair jsonb, counter text) returns text as
$$
declare
    currentDateString   text;
    newDateString       text;
    record              record;
    enclosedWithBracket bool;
    _keyValuePair       text;
begin
    _keyValuePair = keyValuePair;
    IF (select is_valid_json(_keyValuePair))
    THEN
        FOR record IN SELECT * FROM jsonb_each_text(_keyValuePair::jsonb)
            LOOP
                IF (select is_date(record.value))
                THEN
                    currentDateString = record.value;
                    enclosedWithBracket = currentDateString ~ '\[.*?\]';
                    IF (select check_date_format(currentDateString))
                    THEN
                        newDateString :=
                                (select to_char(
                                                ((trim(both '[]' from currentDateString):: timestamp) +
                                                 CAST(counter as interval))::timestamp,
                                                'YYYY-MM-DD'));
                    ELSE
                        newDateString :=
                                (select to_char((select to_char((select TO_DATE(
                                                                                trim(both '[]' from currentDateString),
                                                                                'DD-MM-YYYY')::timestamp),
                                                                'YYYY-MM-DD')::timestamp +
                                                        CAST(counter as interval))::date,
                                                'DD-MM-YYYY'));

                    END IF;
                    RAISE NOTICE '% is date, new date: % , current_date: %', record.key, newDateString, currentDateString;
                    _keyValuePair = jsonb_set(_keyValuePair::jsonb,
                                              concat('{', record.key, '}')::text[],
                                              (case
                                                   when enclosedWithBracket
                                                       then concat('"[', newDateString, ']"')
                                                   else concat('"', newDateString, '"') end)::jsonb);

                ELSE
                    RAISE WARNING '% is not date, value: %', record.key, record.value;
                end if;
            END LOOP;
    END IF;
    return _keyValuePair;
exception
    when others then
        RAISE NOTICE 'Exception';
        return '{}';
end;
$$ language plpgsql;

create or replace function is_valid_json(object text)
    returns boolean
as
$$
begin
    return (object::json is not null);
exception
    when others then
        return false;
end;
$$
    language plpgsql;
