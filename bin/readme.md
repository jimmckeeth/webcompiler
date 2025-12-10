# Pas2js Compiler

This is where the [Pas2Js compiler](https://getpas2js.freepascal.org/) for your platform goes.

The `build.sh` and `build.ps1` scripts should download this all automatically, but here are the details to set it up manually.

* [Windows (intel)](https://getpas2js.freepascal.org/downloads/windows/pas2js-win64-x86_64-current.zip)
* [Linux (amd64)](https://getpas2js.freepascal.org/downloads/linux/pas2js-linux-x86_64-current.zip)
* [Linux (aarch64, e.g. Raspi)](https://getpas2js.freepascal.org/downloads/linux/pas2js-linux-aarch64-current.zip)
* [MacOS Intel (darwin)](https://getpas2js.freepascal.org/downloads/darwin/pas2js-darwin-x86_64-current.zip)
* [MacOS Arch64, i.e. Apple M1 or later (darwin)](https://getpas2js.freepascal.org/downloads/darwin/pas2js-darwin-aarch64-current.zip)

For example, on Windows it would look something like this:

```
📁webcompiler/
├─📁fpc/
├─📁pas2js/
├─📁bin/  ◄━━ YOU ARE HERE
│  ├─📄libpas2js.dll
│  ├─📄pas2js.exe
│  ├─📄pas2js.cfg
│  └─📄etc.
├─📁src/
├  ├─📁sources/
│  │  ├─📄arrayutils.pas
│  │  ├─📄browserconsole.pas
│  │  ├─📄rtl.js
│  │  ├─📄system.pas
│  │  └─📄etc.
│  ├─📄index.html
│  ├─📄run.html
│  ├─📄files.json
│  └─📄webcompiler.js
├─📄build.ps1
├─📄build.sh
└─📄README.md
```
