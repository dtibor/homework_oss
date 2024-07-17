import http.server
import socketserver

PORT = 8000

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hello world')

httpd = socketserver.TCPServer(("", PORT), Handler)

print(f"Serving on port {PORT}")
httpd.serve_forever()
