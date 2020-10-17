import cherrypy
from ws4py.server.cherrypyserver import WebSocketPlugin, WebSocketTool
from ws4py.websocket import WebSocket
from ws4py.websocket import EchoWebSocket

cherrypy.config.update({
    'server.socket_host': '0.0.0.0',
    'server.socket_port': 9000
})

WebSocketPlugin(cherrypy.engine).subscribe()
cherrypy.tools.websocket = WebSocketTool()

class RSHello(object):
    @cherrypy.expose
    def index(self):
        return "Hello motherfucker"

    @cherrypy.expose
    def ws(self):
        handler = cherrypy.request.ws_handler
        cherrypy.log("Handler created: %s" % repr(handler))

class WebSocketHandler(WebSocket):
    def opened(self):
        cherrypy.log("Connection opened")

    def received_message(self, message):
        
        cherrypy.log(message)

cherrypy.quickstart(RSHello(), '', config={
    '/': {
        'tools.response_headers.on': True,
        'tools.response_headers.headers': [
            ('X-Frame-options', 'deny'),
            ('X-XSS-Protection', '1; mode=block'),
            ('X-Content-Type-Options', 'nosniff')
        ]
    },
    '/': {
        'tools.websocket.on': True,
        'tools.websocket.handler_cls': WebSocketHandler
    }
})