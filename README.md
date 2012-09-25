# AVRConnect

Mac OS X applications and libraries for interacting with Denon AVR receivers via the telnet network protocol.

## Using AVRConnect

A prerequisite to building the source is having the [ragel][ragel] state machine compiler installed (available via homebrew: `brew install ragel`). To build the framework or static library (currently OS X), use the Xcode project in [AVRConnect][AVRConnect]. The [Tools][tools] directory contains working examples:

* [AVRConsole][AVRConsole] - uses framework.
* [AVRTest][AVRTest] - uses static library.

[AVRConnect]: https://github.com/jhh/AVRConnect/tree/master/AVRConnect
[AVRTest]: https://github.com/jhh/AVRConnect/tree/master/Tools/AVRTest
[AVRConsole]: https://github.com/jhh/AVRConnect/tree/master/Tools/AVRConsole
[tools]: https://github.com/jhh/AVRConnect/tree/master/Tools
[ragel]: http://www.complang.org/ragel/
