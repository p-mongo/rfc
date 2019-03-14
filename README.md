# RSpec Formatter Collection

A collection of RSpec formatters.

## RSpec Insta-Failing Formatter (RIFF)

RIFF was originally developed for running large test suites in a
continuous integration environment, where the runs are non-interactive
and the output is saved to a file/stream of some kind.
It has the following features;

- Immediate error/failure reporting
- Timestamped percentage progress output
- No output overwrites or terminal manipulation

## Announce Formatter (Announce)

This formatter is similar to the standard RSpec documentation formatter,
but prints the description of each test prior to executing it.
It is intended primarily for debugging, where a breakpoint might be hit
by global test setup code as well as a specific test, or by multiple tests.

This formatter reports failures at the end of the test run, like
RSpec's documentation formatter does.

## Announce Insta-Failing Formatter (AIF)

This is the announce formatter with insta-fail feature. It reports
failures as soon as they happen, after each example is executed.

## License

MIT
