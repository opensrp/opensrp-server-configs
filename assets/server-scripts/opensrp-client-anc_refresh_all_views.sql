SELECT
  core.generate_all_event_type_views(),
  core.create_jsonb_flat_view('client', 'id, date_deleted, server_version', 'json'),
  core.create_jsonb_flat_view('event', 'id, date_deleted, server_version', 'json'),
  core.create_jsonb_nested_flat_view('client', 'id, date_deleted, server_version', 'json', 'identifiers', 'attributes'),
  core.create_core_event_contact_visit_jsonb_flat_view();