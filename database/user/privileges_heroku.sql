-- Table
GRANT SELECT, INSERT ON messages TO :role;

-- Sequence
GRANT USAGE, SELECT ON SEQUENCE messages_global_position_seq TO :role;

-- Functions
GRANT EXECUTE ON FUNCTION gen_random_uuid() TO :role;
GRANT EXECUTE ON FUNCTION md5(text) TO :role;
GRANT EXECUTE ON FUNCTION hash_64(varchar) TO :role;
GRANT EXECUTE ON FUNCTION category(varchar) TO :role;
GRANT EXECUTE ON FUNCTION stream_version(varchar) TO :role;
GRANT EXECUTE ON FUNCTION write_message(varchar, varchar, varchar, jsonb, jsonb, bigint) TO :role;
GRANT EXECUTE ON FUNCTION get_stream_messages(varchar, bigint, bigint, varchar) TO :role;
GRANT EXECUTE ON FUNCTION get_category_messages(varchar, bigint, bigint, varchar) TO :role;
GRANT EXECUTE ON FUNCTION get_last_message(varchar) TO :role;

-- Views
GRANT SELECT ON category_type_summary TO :role;
GRANT SELECT ON stream_summary TO :role;
GRANT SELECT ON stream_type_summary TO :role;
GRANT SELECT ON type_category_summary TO :role;
GRANT SELECT ON type_stream_summary TO :role;
GRANT SELECT ON type_summary TO :role;
