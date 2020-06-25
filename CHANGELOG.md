### 2.4.1

* [FIX] Use iso8601 format for start_date links in the header. Fixes any
  customization to the Rails default date format that might cause the
  parser to fail parsing that with `to_date`

### 2.4.0

* [BREAKING] Fixes Rails 4.2 by changing `block` to `passed_block`. A
  security fix in Rails makes `block` a reserved local name that we can
  no longer use.

  **Upgrading**: If you've customized the simple_calendar views, rename
  `block` to `passed_block`. Without this, calendar dates will be empty.
