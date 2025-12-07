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
`http://localhost:8000/webcompiler.html?file=https://gist.githubusercontent.com/user/id/raw/unit1.pas&file=https://gist.githubusercontent.com/user/id/raw/main.pas`

If a loaded file is named "main" (case-insensitive, e.g., `main.pas`, `main.pp`), it will be automatically opened as the active tab.

## Technologies Used

*   **[Pas2JS](https://wiki.freepascal.org/pas2js)**: The core Pascal to JavaScript compiler.
*   **[CodeMirror 5](https://codemirror.net/5/)**: The versatile text editor component.
*   **[Bootstrap 5](https://getbootstrap.com/)**: For responsive layout and UI components.

## Project Structure

*   `webcompiler.lpr`: The main Pascal project file containing the application logic.
*   `webcompiler.html`: The main entry point for the web application.
*   `files.json`: A JSON array listing the filenames of standard units to be loaded into the virtual file system at startup.
*   `sources/`: Contains the Pascal units (RTL and Compiler) and a default `main.pas` program.

## How It Works

1.  **Initialization**: When `webcompiler.html` loads, it initializes the CodeMirror editor and the Pascal application (`webcompiler.js`).
2.  **Loading Units**: The Pascal application (`TWebCompiler`) fetches `files.json` to get the initial list of available units. It then loads the source code of these standard units (e.g., `system.pas`, `sysutils.pas`, `main.pas`) from the `sources/` directory into a virtual file system (`WebFS`). Additional files can be added to this virtual file system at runtime via URL parameters or interactive UI elements.
3.  **Compilation**: When you click "Run" (or press F9):
    *   The content of the active editor tab is saved to the virtual file system.
    *   `webcompiler.js` invokes the `TPas2JSWebCompiler` class to compile the main program (`main.pas`).
    *   Output messages (errors, hints, warnings) are parsed and displayed in the compiler log and as markers in the editor gutter.
4.  **Execution**: If compilation succeeds:
    *   The generated JavaScript is injected into an isolated IFrame (`runarea`).
    *   The application runs within the IFrame, and its console output is displayed in the "App" tab.

## Building and Updating

To update the web compiler (e.g., after modifying `webcompiler.lpr`), you need to recompile it using the native `pas2js` compiler.

### Updating Unit List

If you add or remove files in the `sources/` directory, you must update `files.json` to reflect these changes. The web compiler reads this file to know which units to load. You can generate this list using a script or command.

For example, in PowerShell:
```powershell
Get-ChildItem -Name sources | ConvertTo-Json > demo/webcompiler/files.json
```

### Build Command

Run from the project root:
```powershell
bin/pas2js.exe -Tbrowser -Jc -O2 "-Fucompiler/utils/pas2js" "-Fucompiler/packages/compat" "-Fucompiler/packages/fcl-json/src" "-Fucompiler/packages/fcl-passrc/src" "-Fucompiler/packages/pastojs/src" "-Fucompiler/packages/fcl-js/src" "-Fupackages/*" demo/webcompiler/webcompiler.lpr
```

### Running

1.  Start the local web server: `node demo/webcompiler/server.js`
2.  Open `http://localhost:8000/webcompiler.html`.
