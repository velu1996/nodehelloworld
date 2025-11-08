const http = require('http');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  const msg = 'Hello Node!\n';
  res.end(msg);
});

// Start the server only when run directly. This allows tests to import the server
// without it immediately listening on a port.
if (require.main === module) {
  server.listen(port, () => {
    console.log(`Server running on http://localhost:${port}/`);
  });
}

module.exports = server;
