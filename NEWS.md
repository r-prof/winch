# winch 0.0.1.9002 (2020-10-13)

- Only enable libbacktrace if it can be configured and built. This fixes problems on Windows oldrelease and Solaris (#34).
- Adapt to trace format with version specification in attribute in rlang 0.4.8 (#35).


# winch 0.0.1.9001 (2020-10-12)

- Copy-edit text (#33, @jawond).
- Fix check on CRAN Debian clang (#32).
- Fix check errors if functionality is not available (#31).


# winch 0.0.1.9000 (2020-09-26)

- Internal changes only.


# winch 0.0.1 (2020-09-26)

Initial release.

- `winch_trace_back()` provides native stack trace as data frame.
- `winch_add_trace_back()` integrates the native stack trace into an rlang traceback.
