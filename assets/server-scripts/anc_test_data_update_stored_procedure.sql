CREATE OR REPLACE FUNCTION update_dates(countParam numeric)
  RETURNS void AS
$$
Declare
counter varchar := CAST(countParam AS text) || 'Month';
r core.event%ROWTYPE;
clientObj core.client%ROWTYPE;
obs jsonb;
photo jsonb;
address jsonb;
obsValues varchar;
contactPoint jsonb;
statusHistoryRecord record;
detailRecord record;
attributeRecord record;
eventDateCreated timestamptz;
eventDateCreatedString varchar;

eventDateEdited timestamptz;
eventDateEditedString varchar;

eventDateVoided timestamptz;
eventDateVoidedString varchar;

eventDate timestamptz;
eventDateString varchar;

obsEffectiveDatetime timestamptz;
obseffectiveDatetimeString varchar;

photoDateCreated timestamptz;
photoDateCreatedString varchar;

eventServerVersion bigint;
eventServerVersionString varchar;

addressStartDate timestamptz;
addressStartDateString varchar;

addressEndDate timestamptz;
addressEndDateString varchar;

contactPointStartDate timestamptz;
contactPointStartDateString varchar;

contactPointEndDate timestamptz;
contactPointEndDateString varchar;

obsValue timestamptz;
obsValueString varchar;

attributeValue timestamptz;
attributeValueString varchar;

statusHistoryValue timestamptz;
statusHistoryValueString varchar;

i integer := 0;
j integer := 0;
loopCounter varchar;
valuesLoopCounter varchar;
BEGIN

-- Event
FOR r IN
SELECT *
FROM core.event e
    LOOP
RAISE NOTICE 'Event is : %', r.id;
IF ((r.json ->> 'dateCreated') is not null) and (r.json ->> 'dateCreated' != '')
THEN
    eventDateCreated := ((r.json ->> 'dateCreated'):: timestamp) + CAST(counter as interval);
    eventDateCreatedString := eventDateCreated::text;

update core.event
set json = jsonb_set(json, '{dateCreated}', concat('"', eventDateCreatedString, '"')::jsonb)
where id = r.id;

END IF;

IF ((r.json ->> 'dateEdited') is not null) and (r.json ->> 'dateEdited' != '')
THEN
--RAISE NOTICE 'Updating dateEdited in Event json : %', r.id;
	eventDateEdited := ((r.json ->> 'dateEdited'):: timestamp) + CAST(counter as interval);
    eventDateEditedString := eventDateEdited::text;
update core.event
set json = jsonb_set(json, '{dateEdited}', concat('"', eventDateEditedString, '"')::jsonb)
where id = r.id;
END IF;

IF ((r.json ->> 'dateVoided') is not null) and (r.json ->> 'dateVoided' != '')
THEN
eventDateVoided:= ((r.json ->> 'dateVoided'):: timestamp) + CAST(counter as interval);
eventDateVoidedString := eventDateVoided::text;

update core.event
set json = jsonb_set(json, '{dateVoided}', concat('"', eventDateVoidedString, '"')::jsonb)
where id = r.id;

END IF;

IF ((r.json ->> 'eventDate') is not null) and (r.json ->> 'eventDate' != '')
THEN
eventDate:= ((r.json ->> 'eventDate'):: timestamp) + CAST(counter as interval);
eventDateString := eventDate::text;

update core.event
set json = jsonb_set(json, '{eventDate}', concat('"', eventDateString, '"')::jsonb)
where id = r.id;

END IF;

IF ((r.json ->> 'serverVersion') is not null) and (r.json ->> 'serverVersion' != '')
THEN
eventServerVersion := extract(epoch from (
to_timestamp((r.json ->> 'serverVersion'):: bigint / 1000 ) + CAST(counter as interval))) * 1000;
eventServerVersionString := eventServerVersion::text;

update core.event
set json = jsonb_set(json, '{serverVersion}', concat('"', eventServerVersionString, '"')::jsonb)
where id = r.id;

END IF;

-- serverVersion
--RAISE NOTICE 'r is %', r.id;
i := 0;
IF ((r.json ->> 'obs') is not null)
THEN
RAISE NOTICE 'Inside inner loop for obs';
FOR obs IN select jsonb_array_elements(r.json -> 'obs')
                      LOOP
--RAISE NOTICE 'Obs is% and event id is %',obs,r.id;
               loopCounter := CAST(i AS text);
RAISE NOTICE 'i = Obs loop is %', loopCounter;
RAISE NOTICE 'Checking for effectiveDateTime when obs[ % ]',loopCounter;
IF ((obs -> 'effectiveDatetime') is not null)
THEN
RAISE NOTICE 'Effective date time is% and event id is %,Obs [ % ]',obs -> 'effectiveDateTime',r.id,loopCounter;
obsEffectiveDatetime:= ((obs ->> 'effectiveDatetime'):: timestamp) + CAST(counter as interval);
obsEffectiveDatetimeString := obsEffectiveDatetime::text;

RAISE NOTICE 'Updating path {obs, % ,effectiveDatetime} with the value of %' , loopCounter,obsEffectiveDatetimeString;
update core.event
set json = jsonb_set(json,concat('{obs,', loopCounter, ',effectiveDatetime}')::text[], concat('"', obsEffectiveDatetimeString, '"')::jsonb)
where id = r.id;
END IF;

IF ((obs -> 'values') is not null)
THEN
--RAISE NOTICE 'Obs is% and event id is %',obs,r.id;
j := 0;
FOR obsValues IN select jsonb_array_elements(obs -> 'values')
                            LOOP
                     valuesLoopCounter := CAST(j AS text);
RAISE NOTICE 'j = Values loop is %', valuesLoopCounter;
RAISE NOTICE 'Checking for obsValue % when obs[ % ] and values[ % ]', obsValues,loopCounter,valuesLoopCounter;
IF((obsValues is not null) and (select is_date(obsValues ::varchar)))
THEN
RAISE NOTICE 'Obs value is % and event id is %, values[ % ], outer Loop Obs[ % ]', obsValues,r.id,valuesLoopCounter,loopCounter;
IF(select checkDateFormat(obsValues))
THEN
RAISE NOTICE 'Inside if block checkdateformat successful';
obsValue := (obsValues:: timestamp) + CAST(counter as interval);
obsValueString := obsValue::text;
ELSE
RAISE NOTICE 'Inside else block checkdateformat not successful';

obsValueString :=
(select to_char((select to_char((select TO_DATE(trim(both '"' from obsValues),
'DD-MM-YYYY')),'YYYY-MM-DD')::timestamp + CAST(counter as interval))::date,'DD-MM-YYYY'));

RAISE NOTICE 'ObsValue computed successfully';
END IF;
RAISE NOTICE 'Updating path {obs, % ,values, %} with the value of %' , loopCounter, valuesLoopCounter,obsValueString;
update core.event
set json = jsonb_set(json,concat('{obs,', loopCounter, ',values,', valuesLoopCounter, '}')::text[], concat('"', obsValueString, '"')::jsonb)
where id = r.id;

END IF;
j := j + 1;
END LOOP;
END IF;

i := i + 1;
END LOOP;
END IF;

-- statusHistory
i := 0;
IF ((r.json ->> 'statusHistory') is not null)
THEN
FOR statusHistoryRecord IN SELECT * FROM jsonb_each_text(r.json -> 'statusHistory')
                                                  LOOP
    RAISE NOTICE 'key %', statusHistoryRecord.key;
RAISE NOTICE 'value %', statusHistoryRecord.value;

IF((statusHistoryRecord.value is not null) and (select is_date(statusHistoryRecord.value ::varchar)))
THEN
RAISE NOTICE 'status History record value is% and event id is %', statusHistoryRecord.value,r.id;
IF(select checkDateFormat(obsValues))
THEN
RAISE NOTICE 'Inside if block checkdateformat successful in status history';
statusHistoryValue := (statusHistoryRecord.value:: timestamp) + CAST(counter as interval);
statusHistoryValueString := statusHistoryValue::text;
ELSE
RAISE NOTICE 'inside else block of status history';
RAISE NOTICE 'ELSE BLOCK STATUS HISTORY : %', (select to_char((select to_char((select TO_DATE(trim(both '"' from statusHistoryRecord.value),
'DD-MM-YYYY')),'YYYY-MM-DD')::timestamp + CAST(counter as interval))::date,'DD-MM-YYYY'));

statusHistoryValueString :=
(select to_char((select to_char((select TO_DATE(trim(both '"' from statusHistoryRecord.value),
'DD-MM-YYYY')),'YYYY-MM-DD')::timestamp + CAST(counter as interval))::date,'DD-MM-YYYY'));

RAISE NOTICE 'statusHistoryRecord.value computed successfully';
END IF;
RAISE NOTICE 'Updating path {statusHistory, % } with the value of % and event id is %' , statusHistoryRecord.key,statusHistoryValueString,r.id;
update core.event
set json = jsonb_set(json,concat('{statusHistory,', statusHistoryRecord.key,'}')::text[], concat('"', statusHistoryValueString, '"')::jsonb)
where id = r.id;

END IF;

	i := i + 1;
END LOOP;
END IF;

-- details
i := 0;
IF ((r.json ->> 'details') is not null)
THEN
FOR detailRecord IN SELECT * FROM jsonb_each_text(r.json -> 'details')
                                           LOOP
    RAISE NOTICE 'key %', detailRecord.key;
RAISE NOTICE 'value %', detailRecord.value;

IF((detailRecord.value is not null) and (select is_date(detailRecord.value ::varchar)))
THEN
END IF;
i := i + 1;
END LOOP;
END IF;

--photos
i := 0;
IF ((r.json ->> 'photos') is not null)
THEN
--RAISE NOTICE 'Inside inner loop for photos';
FOR photo IN select jsonb_array_elements(r.json -> 'photos')
    LOOP
                      RAISE NOTICE 'Photos is % and event id is %',photo,r.id;
loopCounter := CAST(i AS text);
IF ((photo ->> 'dateCreated') is not null)
THEN
RAISE NOTICE 'Photo is is% and event id is %',photo,r.id;
IF(select checkDateFormat(photo ->> 'dateCreated'))
THEN
photoDateCreated:= ((photo ->> 'dateCreated'):: timestamp) + CAST(counter as interval);
photoDateCreatedString := photoDateCreated::text;
ELSE
photoDateCreatedString :=
(select to_char((select to_char((select TO_DATE(trim(both '"' from photo ->> 'dateCreated'),
'DD-MM-YYYY')),'YYYY-MM-DD')::timestamp + CAST(counter as interval))::date,'DD-MM-YYYY'));

END IF;
update core.event
set json = jsonb_set(json,concat('{photos,', loopCounter, ',dateCreated}')::text[], concat('"', photoDateCreatedString, '"')::jsonb)
where id = r.id;
END IF;
i := i + 1;
END LOOP;
END IF;
END LOOP;

UPDATE core.event
SET date_deleted = date_deleted + CAST(counter as interval);

UPDATE core.event
SET server_version = extract(epoch from (
        to_timestamp(server_version) + CAST(counter as interval)));

-- event_metadata
UPDATE core.event_metadata
SET event_date = event_date + CAST(counter as interval);

UPDATE core.event_metadata
SET date_created = date_created + CAST(counter as interval);

UPDATE core.event_metadata
SET date_edited = date_edited + CAST(counter as interval);

UPDATE core.event_metadata
SET date_deleted = date_deleted + CAST(counter as interval);

UPDATE core.event_metadata
SET server_version = extract(epoch from (
        to_timestamp(server_version / 1000 :: bigint) + CAST(counter as interval))) * 1000;

-- client
FOR clientObj IN
SELECT *
FROM core.client client
    LOOP

i := 0;
IF (clientObj.json -> 'addresses' is not null)
THEN
RAISE NOTICE 'Inside inner loop for addresses';
FOR address IN select jsonb_array_elements(clientObj.json -> 'addresses')
    LOOP
                   RAISE NOTICE 'Address is% and client id is %',address,clientObj.id;
loopCounter := CAST(i AS text);
IF ((address ->> 'startDate') is not null)
THEN
addressStartDate:= ((address ->> 'startDate'):: timestamp) + CAST(counter as interval);
addressStartDateString := addressStartDate::text;

RAISE NOTICE 'updating address ---- {addresses, % ,startDate} where client id is % and addressstartdateString is : %', loopCounter, clientObj.id, addressStartDateString;
update core.client
set json = jsonb_set(json,concat('{addresses,', loopCounter, ',startDate}')::text[], concat('"', addressStartDateString, '"')::jsonb)
where id = clientObj.id;
END IF;

IF ((address ->> 'endDate') is not null)
THEN
addressEndDate:= ((address ->> 'endDate'):: timestamp) + CAST(counter as interval);
addressEndDateString := addressEndDate::text;

update core.client
set json = jsonb_set(json,concat('{addresses,', loopCounter, ',endDate}')::text[], concat('"', addressEndDateString, '"')::jsonb)
where id = clientObj.id;
END IF;

i := i + 1;
END LOOP;
END IF;

i := 0;
IF (clientObj.json ->> 'contactPoints' is not null)
THEN
RAISE NOTICE 'Inside inner loop for contactPoints';
FOR contactPoint IN select jsonb_array_elements(clientObj.json -> 'contactPoints')
    LOOP
                        RAISE NOTICE 'contactPoint is% and client id is %',contactPoint,clientObj.id;
loopCounter := CAST(i AS text);
IF ((contactPoint ->> 'startDate') is not null)
THEN
contactPointStartDate:= ((contactPoint ->> 'startDate'):: timestamp) + CAST(counter as interval);
contactPointStartDateString := contactPointStartDate::text;

RAISE NOTICE 'updating contactPoints, % ,startDate} where clientObj id is : % and string updated value is : %', loopCounter, clientObj.id, contactPointStartDateString;
update core.client
set json = jsonb_set(json,concat('{contactPoints,', loopCounter, ',startDate}')::text[], concat('"', contactPointStartDateString, '"')::jsonb)
where id = clientObj.id;
END IF;

IF ((contactPoint -> 'endDate') is not null)
THEN
contactPointEndDate:= ((contactPoint ->> 'endDate'):: timestamp) + CAST(counter as interval);
contactPointEndDateString := contactPointEndDate::text;

update core.client
set json = jsonb_set(json,concat('{contactPoints,', loopCounter, ',endDate}')::text[], concat('"', contactPointEndDateString, '"')::jsonb)
where id = clientObj.id;
END IF;

i := i + 1;
END LOOP;
END IF;

--photos
i := 0;
IF ((clientObj.json ->> 'photos') is not null)
THEN
--RAISE NOTICE 'Inside inner loop for photos';
FOR photo IN select jsonb_array_elements(clientObj.json -> 'photos')
                             LOOP
--RAISE NOTICE 'Photos is % and event id is %',photo,clientObj.id;
                      loopCounter := CAST(i AS text);
IF ((photo ->> 'dateCreated') is not null)
THEN
--RAISE NOTICE 'Photo is is% and event id is %',photo,r.id;
photoDateCreated:= ((photo ->> 'dateCreated'):: timestamp) + CAST(counter as interval);
photoDateCreatedString := photoDateCreated::text;

update core.client
set json = jsonb_set(json,concat('{photos,', loopCounter, ',dateCreated}')::text[], concat('"', photoDateCreatedString, '"')::jsonb)
where id = clientObj.id;
END IF;
i := i + 1;
END LOOP;
END IF;

-- attributes
i := 0;
IF ((clientObj.json ->> 'attributes') is not null)
THEN
FOR attributeRecord IN SELECT * FROM jsonb_each_text(clientObj.json -> 'attributes')
                                              LOOP
    RAISE NOTICE 'key %', attributeRecord.key;
RAISE NOTICE 'value %', attributeRecord.value;

IF((attributeRecord.value is not null) and (select is_date(attributeRecord.value ::varchar)))
THEN
RAISE NOTICE 'attribute record value is% and client id is %', attributeRecord.value,clientObj.id;
attributeValue := (attributeRecord.value:: timestamp) + CAST(counter as interval);
attributeValueString := attributeValue::text;

RAISE NOTICE 'Updating path {attributes, % } with the value of % and client id is %' , attributeRecord.key,attributeValueString,clientObj.id;
update core.client
set json = jsonb_set(json,concat('{attributes,', attributeRecord.key,'}')::text[], concat('"', attributeValueString, '"')::jsonb)
where id = clientObj.id;

END IF;

	i := i + 1;
END LOOP;
END IF;

END LOOP;

UPDATE core.client
SET date_deleted = date_deleted + CAST(counter as interval);

UPDATE core.client
SET server_version = extract(epoch from (
        to_timestamp(server_version / 1000 :: bigint) + CAST(counter as interval))) * 1000;

-- client_metadata

UPDATE core.client_metadata
SET birth_date = birth_date + CAST(counter as interval);

UPDATE core.client_metadata
SET date_deleted = date_deleted + CAST(counter as interval);

UPDATE core.client_metadata
SET date_created = date_created + CAST(counter as interval);

UPDATE core.client_metadata
SET date_edited = date_edited + CAST(counter as interval);

UPDATE core.client_metadata
SET server_version = extract(epoch from (
        to_timestamp(server_version / 1000 :: bigint) + CAST(counter as interval))) * 1000;

END;
$$
LANGUAGE plpgsql;

create or replace function is_date(s varchar) returns boolean as $$
declare
dateString varchar;
begin
  RAISE NOTICE 'date is % ', s;
  RAISE NOTICE 'date is % in text', s::text;
  RAISE NOTICE 'checking if condtion of date, AFTER TRIMMING %' , trim(both '"' from s);
  IF(trim(both '"' from s) ~ '[a-z]')
  THEN
  RAISE NOTICE 'Date string from a-z';
return false;
END IF;
  IF(trim(both '"' from s) ~ '[0-9]{2}-[0-9]{2}-[0-9]{4}')
  THEN
  RAISE NOTICE 'inside if block of date';
return true;
END IF;
  perform s::date;
return true;
exception when others then
  RAISE NOTICE 'inside exception block';
return false;
end;
$$ language plpgsql;

create or replace function checkDateFormat(s varchar) returns boolean as $$
declare
begin
  RAISE NOTICE 'date is % ', s;
  RAISE NOTICE 'checking if condtionr of date, AFTER TRIMMING %' , trim(both '"' from s);
  IF(trim(both '"' from s) ~ '[0-9]{4}-[0-9]{2}-[0-9]{2}')
  THEN
  RAISE NOTICE 'inside if block of date format checker';
return true;
END IF;
return false;
exception when others then
  RAISE NOTICE 'inside exception block of date format checker';
return false;
end;
$$ language plpgsql;
