### 2.4.0

* [BREAKING] Fixes Rails 4.2 by changing `block` to `passed_block`. A
  security fix in Rails makes `block` a reserved local name that we can
  no longer use.

  **Upgrading**: If you've customized the simple_calendar views, rename
  `block` to `passed_block`. Without this, calendar dates will be empty.
