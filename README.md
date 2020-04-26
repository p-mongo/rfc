# RSpec Formatter Collection

A collection of RSpec formatters.


## RSpec Insta-Failing Formatter (`Rif`, `Riff`)

This formatter was originally developed for running large test suites in a
continuous integration environment, where the runs are non-interactive
and the output is saved to a file/stream of some kind.
It has the following features;

- Immediate error/failure reporting
- Timestamped percentage progress output
- No output overwrites or terminal manipulation
- Optionally reports system statistics

To assist in diagnosing test failures caused by resource exhaustion,
`Rif` can output the following additional statistics:

- Ruby object space stats: number of objects total and free
- System memory stats: memory and swap used, free and total
- CPU stats: average CPU load during test suite execution

To enable object space stastistics reporting, add to your `spec_helper.rb`:

    Rfc::Rif.output_object_space_stats = true

To enable memory and CPU statistics reporting, add to your `spec_helper.rb`:

    Rfc::Rif.output_system_load = true

At the end of the run Aif lists up to the first 10 pending examples.


## Announce Formatter (Announce)

This formatter is similar to the standard RSpec documentation formatter,
but prints the description of each test prior to executing it.
It is intended primarily for debugging, where a breakpoint might be hit
by global test setup code as well as a specific test, or by multiple tests.

This formatter reports failures at the end of the test run, like
RSpec's documentation formatter does.


## Announce Insta-Failing Formatter (Aif, AIF)

This is the announce formatter with insta-fail feature. It reports
failures as soon as they happen, after each example is executed.

At the end of the run Aif lists up to the first 10 pending examples.


## License

MIT
