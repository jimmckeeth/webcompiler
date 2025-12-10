# Webcompiler

This is fully built and ready to go. Just deploy the following files onto your webserver:

* **[webcompiler.js](https://github.com/delphiorg/webcompiler/blob/main/src/webcompiler.js)** - This is the JavaScript compiled compiler. It is minified, but you can always rebuild it, or the [raw (non-minified) version is still available](https://github.com/delphiorg/webcompiler/blob/main/src/webcompiler-raw.js), just rename it and you can swap it out. 
* **[files.json](https://github.com/delphiorg/webcompiler/blob/main/src/files.json)** - This is list of all the files in the sources folder. It is used both by the index.html and webcompiler.js to keep in sync. There are probably too many files in there now, so you can probably reduce it with some testing.
* **[index.html](https://github.com/delphiorg/webcompiler/blob/main/src/index.html)** - The landing page. It uses [CodeMirror](https://codemirror.net/) as the code editor, with the [dracula](https://draculatheme.com/) and [eclipse theme](https://codemirror.net/5/theme/).
* **[run.html](https://github.com/delphiorg/webcompiler/blob/main/src/run.html)** - The container for the output of the program run.
* **[souces](https://github.com/delphiorg/webcompiler/blob/main/src/webcompiler.js)** - the whole folder, with all the files in it.

There is functionality for loding files into multiple tabs and loading files from from an external URL (like a raw GitHub gist for example.) But the compiler doesn't load them in yet.

This is the rough directory structure for your repository

```
📁webcompiler/
├─📁fpc/
├─📁pas2js/
├─📁bin/
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
│  ├─📄readme.md ◄━	 YOU ARE HERE
│  ├─📄index.html
│  ├─📄run.html
│  ├─📄files.json
│  └─📄webcompiler.js
├─📄build.ps1
├─📄build.sh
└─📄README.md
```
