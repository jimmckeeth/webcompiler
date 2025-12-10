# Pas2JS Web Compiler

This is a modern, fully functional web-based IDE and compiler for Pas2JS. It allows you to write Pascal code, compile it directly in the browser, and run it, all within a responsive and themed interface.

## Features

*   **In-Browser Compilation**: Uses `pas2js` compiled to JavaScript to compile Pascal code on the fly.
*   **Modern Editor**: Integrated CodeMirror 5 editor with Pascal syntax highlighting.
*   **Multi-File Support**: Create, edit, and compile multiple units. Includes a sidebar file explorer, interactive 'New File' creation, and 'Add URL' (e.g., from GitHub Gist) functionalities.
*   **IDE Features**:
    *   **Syntax Highlighting**: Full Pascal syntax support.
    *   **Autocomplete**: Basic keyword completion using `Ctrl-Space`.
    *   **Error Visualization**: Compiler errors are parsed and displayed as markers (red dots) in the editor gutter.
    *   **Tabs**: Open multiple files in tabs for easy switching and editing.
*   **Theming**: Automatically switches between **Light** and **Dark (Dracula)** themes based on your operating system/browser preferences.
*   **Integrated Layout**: 3-column layout with File Explorer, Editor, and Output.
*   **Keyboard Shortcuts**: `F9` to Compile and Run.

## URL Loading & Gists

You can automatically load source files from external URLs (like GitHub Gists) by appending `?file=<url>` to the web compiler URL. You can load multiple files this way.

**Example:**
`http://localhost:8000/index.html?file=https://gist.githubusercontent.com/user/id/raw/unit1.pas&file=https://gist.githubusercontent.com/user/id/raw/main.pas`

If a loaded file is named "main" (case-insensitive, e.g., `main.pas`, `main.pp`), it will be automatically opened as the active tab.

## Technologies Used

*   **[Pas2JS](https://wiki.freepascal.org/pas2js)**: The core Pascal to JavaScript compiler.
*   **[CodeMirror 5](https://codemirror.net/5/)**: The versatile text editor component.
*   **[Bootstrap 5](https://getbootstrap.com/)**: For responsive layout and UI components.

## Project Structure

*   `webcompiler.lpr`: The main Pascal project file containing the application logic.
*   `index.html`: The main entry point for the web application.
*   `files.json`: A JSON array listing the filenames of standard units to be loaded into the virtual file system at startup.
*   `sources/`: Contains the Pascal units (RTL and Compiler) and a default `main.pas` program.

## How It Works

1.  **Initialization**: When `index.html` loads, it initializes the CodeMirror editor and the Pascal application (`webcompiler.js`).
2.  **Loading Units**: The Pascal application (`TWebCompiler`) fetches `files.json` to get the initial list of available units. It then loads the source code of these standard units (e.g., `system.pas`, `sysutils.pas`, `main.pas`) from the `sources/` directory into a virtual file system (`WebFS`). Additional files can be added to this virtual file system at runtime via URL parameters or interactive UI elements.
3.  **Compilation**: When you click "Run" (or press F9):
    *   The content of the active editor tab is saved to the virtual file system.
    *   `webcompiler.js` invokes the `TPas2JSWebCompiler` class to compile the main program (`main.pas`).
    *   Output messages (errors, hints, warnings) are parsed and displayed in the compiler log and as markers in the editor gutter.
4.  **Execution**: If compilation succeeds:
    *   The generated JavaScript is injected into an isolated IFrame (`runarea`).
    *   The application runs within the IFrame, and its console output is displayed in the "App" tab.

### Updating Unit List

If you add or remove files in the `sources/` directory, you must update `files.json` to reflect these changes. The web compiler reads this file to know which units to load. You can generate this list using a script or command.

For example, in PowerShell:
```powershell
Get-ChildItem -Name sources | ConvertTo-Json > demo/webcompiler/files.json
```

### Build Command

This is all automated with `[build.ps1](https://github.com/delphiorg/webcompiler/blob/main/build.ps1)` or `[build.sh](https://github.com/delphiorg/webcompiler/blob/main/build.sh)`, and there is a workflow setup to build and deploy this to GitHub Pages too (using `build.sh`).

#### Manual Process

Before you can rebuild, you need to download FPC and Pas2js into their respective folders. They are setup as git submodules, which simplified this. There are 3 ways to do this:

* To clone this repo and and the submodules at the same time use `git clone --recursive` 
* If you've already cloned this repo then to download just the submodules run `git submodule update --init`
* If you want to update the submodules to the latest version `git submodule update --remote`

You need to download the Pas2js compiler for your platform into the [bin folder](/bin).

You also need to 

Once you have the prerequisites

Run from the project root:
```powershell
bin/pas2js.exe -Tbrowser -Jc -O2 "-Fucompiler/utils/pas2js" "-Fucompiler/packages/compat" "-Fucompiler/packages/fcl-json/src" "-Fucompiler/packages/fcl-passrc/src" "-Fucompiler/packages/pastojs/src" "-Fucompiler/packages/fcl-js/src" "-Fupackages/*" demo/webcompiler/webcompiler.lpr
```

### Running

1.  Start the local web server: `node demo/webcompiler/server.js`
2.  Open `http://localhost:8000/index.html`.

## Directory Structure

This is a rough estimate of what your directory structure should look like. There is a readme in the [bin folder](/bin), and another in the [src folder](/src/readme.md) with more information on building and deployment.

```
📁webcompiler/ ◄━	 YOU ARE HERE
├─📁fpc/    (submodule)
├─📁pas2js/ (submodule)
├─📁bin/    (download)
│  ├─📄libpas2js.dll
│  ├─📄pas2js.exe
│  ├─📄pas2js.cfg
│  └─📄etc.
├─📁src/    (deploy)
├  ├─📁sources/
│  │  ├─📄arrayutils.pas
│  │  ├─📄browserconsole.pas
│  │  ├─📄rtl.js
│  │  ├─📄system.pas
│  │  └─📄etc.
│  ├─📄readme.md 
│  ├─📄index.html
│  ├─📄run.html
│  ├─📄files.json
│  └─📄webcompiler.js
├─📄build.ps1
├─📄build.sh
└─📄README.md
```
