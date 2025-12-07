const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 8000;
const baseDir = __dirname;

http.createServer((req, res) => {
  // Handle query parameters by ignoring them for file lookup
  const urlPath = req.url.split('?')[0];
  let filePath = path.join(baseDir, urlPath === '/' ? 'webcompiler.html' : urlPath);
  
  const extname = path.extname(filePath);
  let contentType = 'text/html';
  
  switch (extname) {
    case '.js': contentType = 'text/javascript'; break;
    case '.css': contentType = 'text/css'; break;
    case '.json': contentType = 'application/json'; break;
    case '.png': contentType = 'image/png'; break;
    case '.jpg': contentType = 'image/jpg'; break;
    case '.pas': contentType = 'text/plain'; break;
    case '.pp': contentType = 'text/plain'; break;
  }

  fs.readFile(filePath, (error, content) => {
    if (error) {
      if(error.code == 'ENOENT') {
        res.writeHead(404);
        res.end('404 Not Found: ' + filePath);
        console.log('404: ' + filePath);
      } else {
        res.writeHead(500);
        res.end('500 Error: ' + error.code);
        console.log('500: ' + filePath);
      }
    } else {
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(content, 'utf-8');
    }
  });
}).listen(port);

console.log(`Server running at http://localhost:${port}/`);
