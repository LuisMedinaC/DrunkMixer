import cherrypy
import socket

class RSHello(object):

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def __init__(self):
        RSHello.sock.connect(('127.0.0.1', 55555))

    @cherrypy.expose
    def index(self):
        return "Hello"

    @cherrypy.expose
    def left(self):
        RSHello.sock.send(bytes("l", 'UTF-8'))
        return "Left"
    
    @cherrypy.expose
    def right(self):
        RSHello.sock.send(bytes("r", 'UTF-8'))
        return "Right"

if __name__ == '__main__':
    cherrypy.config.update({
        'server.socket_host': '0.0.0.0',
        'server.socket_port': 9000
    })

    root = RSHello()
    cherrypy.quickstart(root)
