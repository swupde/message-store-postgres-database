#!/usr/bin/env bash

set -e

echo
echo "Installing Database"
echo "= = ="
echo

default_name=message_store
if [ -z ${MESSAGE_STORE_URL+x} ]; then
  echo "(MESSAGE_STORE_URL is not set. Aborting.)"
  exit
fi

echo

function script_dir {
  val="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "$val"
}


function create-extensions {
  base=$(script_dir)
  psql $MESSAGE_STORE_URL -f $base/extension/pgcrypto.sql
  echo
}

function create-table {
  base=$(script_dir)
  psql $MESSAGE_STORE_URL -f $base/table/messages.sql
  echo
}

function create-types {
  base=$(script_dir)

  echo "message type"
  psql $MESSAGE_STORE_URL -f $base/types/message.sql

  echo
}

function create-functions {
  base=$(script_dir)

  echo "hash_64 function"
  psql $MESSAGE_STORE_URL -f $base/functions/hash-64.sql

  echo "category function"
  psql $MESSAGE_STORE_URL -f $base/functions/category.sql

  echo "stream_version function"
  psql $MESSAGE_STORE_URL -f $base/functions/stream-version.sql

  echo "write_message function"
  psql $MESSAGE_STORE_URL -f $base/functions/write-message.sql

  echo "get_stream_messages function"
  psql $MESSAGE_STORE_URL -f $base/functions/get-stream-messages.sql

  echo "get_category_messages function"
  psql $MESSAGE_STORE_URL -f $base/functions/get-category-messages.sql

  echo "get_last_message function"
  psql $MESSAGE_STORE_URL -f $base/functions/get-last-message.sql

  echo
}

function create-indexes {
  base=$(script_dir)

  echo "messages_id_uniq_idx"
  psql $MESSAGE_STORE_URL -f $base/indexes/messages-id-uniq.sql

  echo "messages_category_global_position_idx"
  psql $MESSAGE_STORE_URL -f $base/indexes/messages-category-global-position.sql

  echo "messages_stream_name_position_uniq_idx"
  psql $MESSAGE_STORE_URL -f $base/indexes/messages-stream-name-position-uniq.sql

  echo
}

function create-views {
  base=$(script_dir)

  echo "stream_summary view"
  psql $MESSAGE_STORE_URL -f $base/views/stream-summary.sql

  echo "type_summary view"
  psql $MESSAGE_STORE_URL -f $base/views/type-summary.sql

  echo "type_stream_summary view"
  psql $MESSAGE_STORE_URL -f $base/views/stream-type-summary.sql

  echo "type_stream_summary view"
  psql $MESSAGE_STORE_URL -f $base/views/type-stream-summary.sql

  echo "category_type_summary view"
  psql $MESSAGE_STORE_URL -f $base/views/category-type-summary.sql

  echo "type_category_summary view"
  psql $MESSAGE_STORE_URL -f $base/views/type-category-summary.sql

  echo
}

function grant-privileges {
  base=$(script_dir)
  role="$(echo $MESSAGE_STORE_URL | grep @ | cut -d: -f2 | sed 's/\/*//')"
  psql $MESSAGE_STORE_URL -v role=$role -f $base/user/privileges_heroku.sql
  echo
}


base=$(script_dir)


echo
echo "Creating Table"
echo "- - -"
create-table

# Install functions

echo
echo "Creating Types"
echo "- - -"
create-types

echo
echo "Creating Functions"
echo "- - -"
create-functions

echo
echo "Creating Indexes"
echo "- - -"
create-indexes

echo
echo "Creating Views"
echo "- - -"
create-views

echo
echo "Granting Privileges"
echo "- - -"
grant-privileges

