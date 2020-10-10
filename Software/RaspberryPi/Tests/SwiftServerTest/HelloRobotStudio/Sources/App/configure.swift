import Vapor

final class RSClient {
    
    var socket: WebSocket
    
    init(socket: WebSocket) {
        self.socket = socket
    }
    
    func moveRight() {
        socket.send("1")
    }
    
    func moveLeft() {
        socket.send("0")
    }
}


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080
    
    var rsClient: RSClient!
    
    app.get { (res) -> String in
        return "Hello"
    }
    
    
    app.get("right") { req -> String in
        print("Move right")
        rsClient?.moveRight()
        return "OK"
    }
    
    app.get("left") { req -> String in
        print("Move left")
        rsClient?.moveLeft()
        return "OK"
    }
    
    app.webSocket("channel") { (req, ws) in
        
        print(req)
        rsClient = RSClient(socket: ws)
        
        ws.onText { (ws, message) in
            print("Receive message")
            
            if message == "0" {
                print("Start connection")
            }
            
            if message == "1" {
                print("Done")
            }
            
        }
        
    }
}


