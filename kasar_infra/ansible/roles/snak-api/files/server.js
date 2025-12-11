import http from "http";
import fs from "fs";
import path from "path";

const server = http.createServer((req, res) => {
  if (req.url === "/api" || req.url === "/api/") {
    const indexPath = path.join(process.cwd(), "index.html");
    fs.readFile(indexPath, (err, data) => {
      if (err) {
        res.writeHead(500, { "Content-Type": "text/plain" });
        res.end("Error loading backend index.html");
        return;
      }
      res.writeHead(200, { "Content-Type": "text/html" });
      res.end(data);
    });
  } else if (req.url === "/api/headers") {
    // Dump all headers
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify(req.headers, null, 2));
  } else if (req.url === "/api/userinfo") {
    // User-related headers injectés par oauth2-proxy
    const user = req.headers["x-auth-request-user"] || null;
    const email = req.headers["x-auth-request-email"] || null;
    const token = req.headers["authorization"] || null;
    console.log("Headers received:", req.headers);

    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ user, email, token }, null, 2));
  } else {
    res.writeHead(404, { "Content-Type": "text/plain" });
    res.end("Not found");
  }
});

server.listen(8081, () => {
  console.log("✅ Dummy backend listening on port 8081");
});
