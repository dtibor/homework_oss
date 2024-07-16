import http.server
import socketserver

PORT = 8000

class HelloWorldHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(b"Hello, World!")
        else:
            self.send_error(404, "File not found")

with socketserver.TCPServer(("", PORT), HelloWorldHandler) as httpd:
    print(f"Serving on port {PORT}")
    httpd.serve_forever()
