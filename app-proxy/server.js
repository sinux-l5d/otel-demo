import http from 'http';
import https from 'https';
import { parse } from 'url';

const targetUrl = process.argv[2];

const server = http.createServer((req, res) => {
  if (!targetUrl) {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello, world!');
    return;
  }

  const parsedUrl = parse(targetUrl);
  const protocol = parsedUrl.protocol === 'https:' ? https : http;

  protocol.get(targetUrl, (response) => {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      // Log code and body in one line
      console.error(`message="Failed to fetch the URL" status=${response.statusCode}`);
      res.writeHead(418, { 'Content-Type': 'text/plain' });
      res.end("418 I'm a teapot");
      return;
    }

    let data = '';
    response.on('data', (chunk) => {
      data += chunk;
    });

    response.on('end', () => {
      res.writeHead(response.statusCode, { 'Content-Type': 'text/plain' });
      res.end(data);
    });
  }).on('error', (err) => {
    res.writeHead(500, { 'Content-Type': 'text/plain' });
    res.end('Failed to fetch the URL');
    console.error(`message="Failed to fetch the URL" error="${err.message}"`);
  });
});

server.listen(8080, () => {
  console.log('Server is listening on port 8080');
  console.log(`Proxying requests to ${targetUrl}`);
});

// Graceful shutdown
const shutdown = () => {
  console.log('Received shutdown signal, shutting down gracefully...');
  server.close(() => {
    console.log('Closed out remaining connections.');
    process.exit(0);
  });

  // Force shutdown after 10 seconds
  setTimeout(() => {
    console.error('Could not close connections in time, forcefully shutting down');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

