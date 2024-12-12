<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# winch 0.1.1.9001 (2024-12-12)

## Chore

- Auto-update from GitHub Actions.

  Run: https://github.com/r-prof/winch/actions/runs/10425483563

- Auto-update from GitHub Actions.

  Run: https://github.com/r-prof/winch/actions/runs/10224245868

- Auto-update from GitHub Actions.

  Run: https://github.com/r-prof/winch/actions/runs/10208525483

- Auto-update from GitHub Actions.

  Run: https://github.com/r-prof/winch/actions/runs/9728442265

- Auto-update from GitHub Actions.

  Run: https://github.com/r-prof/winch/actions/runs/9691617471

## Continuous integration

- Avoid failure in fledge workflow if no changes (#82).

- Fetch tags for fledge workflow to avoid unnecessary NEWS entries (#81).

- Use larger retry count for lock-threads workflow (#80).

- Ignore errors when removing pkg-config on macOS (#79).

- Explicit permissions (#78).

- Use styler from main branch (#77).

- Need to install R on Ubuntu 24.04 (#76).

- Use Ubuntu 24.04 and styler PR (#74).

- Correctly detect branch protection (#73).

- Use stable pak (#72).

- Trigger run (#71).

- Use pkgdown branch (#70).

- Install via R CMD INSTALL ., not pak (#69).

- Install local package for pkgdown builds.

- Improve support for protected branches with fledge.

- Improve support for protected branches, without fledge.

- Sync with latest developments.

- Use v2 instead of master.

- Import from actions-sync, check carefully.

- Import from actions-sync, check carefully.

- Avoid checking bashisms on Windows.


# winch 0.1.1.9000 (2024-02-19)

- Merge branch 'cran-0.1.1'.


# winch 0.1.1 (2024-02-19)

## Bug fixes

- Gracefully degrade if `unw_get_proc_name()` results in an error.


# winch 0.1.0 (2023-04-19)

## Features

- `winch_trace_back()` returns a new `is_libr` column that indicates if an entry is from R's shared library (#56).

## Chore

- Deprecate `winch_add_trace_back()`, to be reimplemented in rlang (#56).

- Tweak snapshot.

- Fix compiler warning regarding empty prototype.


# winch 0.0.12 (2023-01-30)

## Chore

- Fix compiler warnings (@Antonov548, #63).


# winch 0.0.11 (2022-10-31)

## Bug fixes

- Fix prototype warning (@Antonov548, #60).


# winch 0.0.10 (2022-10-20)

## Bug fixes

- Fix deprecation warnings (@Antonov548, #58).


# winch 0.0.9 (2022-08-31)

## Breaking changes

- rlang backtraces are disabled for now (#56).


# winch 0.0.8 (2022-03-16)

- Fix compatibility with vctrs > 0.3.8.


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
