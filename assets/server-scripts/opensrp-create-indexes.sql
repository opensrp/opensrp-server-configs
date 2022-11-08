CREATE INDEX "client_json_baseEntityId_idx" ON core.client (("json" ->> 'baseEntityId'));

CREATE INDEX "event_json_eventType_idx" ON core."event" (("json" ->> 'eventType'));

CREATE INDEX "event_json_baseEntityId_idx" ON core."event" (("json" ->> 'baseEntityId'));
