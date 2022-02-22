<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# winch 0.0.7.9001 (2022-02-22)

- Fix compatibility with vctrs > 0.3.8.


# winch 0.0.7.9000 (2021-10-24)

- Same as previous version.


# winch 0.0.7 (2021-10-24)

- Fix compatibility with dev rlang (#50).
- Use correct `printf()` format for `uintptr_t` (#48, @QuLogic).


# winch 0.0.6 (2020-11-16)

- Work around CRAN check failures on Linux with C locale and Windows oldrel (#45).

- Enable more tests on CRAN (#43).


# winch 0.0.5 (2020-11-03)

- Fix checks when libbacktrace compiles but is broken (#40).

- Vendor libraries are not checked on Valgrind (#41).


# winch 0.0.4 (2020-10-20)

- Avoid `-j` and `-l` when calling `make`.


# winch 0.0.3 (2020-10-15)

- Same as winch 0.0.2.


# winch 0.0.2 (2020-10-13)

- Adapt to trace format with version specification in attribute in rlang 0.4.8 (#35).

- Fix Valgrind error.

- Fix check errors if functionality is not available (#31).

- Fix check on CRAN Debian clang (#32).

- Only enable libbacktrace if it can be configured and built. This fixes problems on Windows oldrelease and Solaris (#34).

- Copy-edit text (#33, @jawond).


# winch 0.0.1 (2020-09-26)

Initial release.

- `winch_trace_back()` provides native stack trace as data frame.
- `winch_add_trace_back()` integrates the native stack trace into an rlang traceback.
