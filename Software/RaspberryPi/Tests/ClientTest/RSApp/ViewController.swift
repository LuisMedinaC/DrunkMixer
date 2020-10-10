//
//  ViewController.swift
//  RSApp
//
//  Created by Aldo Fuentes on 03/10/20.
//

import UIKit
import Starscream

extension UIColor {
    static var buttonBlue: UIColor = UIColor(hue: 212/360, saturation: 0.99, brightness: 1, alpha: 1)
}

class ViewController: UIViewController {

    var leftBtn: UIButton! = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.buttonBlue
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Left", for: .normal)
        btn.applyShadow()
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var rightBtn: UIButton! = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.buttonBlue
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Right", for: .normal)
        btn.applyShadow()
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var websocket: WebSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBtn.addTarget(self, action: #selector(btnHandler(_:)), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(btnHandler(_:)), for: .touchUpInside)
        setupLayout()
        testWebsocket()
    }
    
    func setupLayout() {
        view.addSubviews([leftBtn, rightBtn])
        
        rightBtn.constraintTo(view.safeAreaLayoutGuide, attributes: [.right, .bottom], insets: UIEdgeInsets(25, 50))
        leftBtn.constraintTo(view.safeAreaLayoutGuide, attributes: [.left, .bottom], insets: UIEdgeInsets(25, 50))
        
        rightBtn.constraintHeightTo(constant: 50)
        rightBtn.constraintWidthTo(leftBtn)
        
        leftBtn.constraintHeightTo(constant: 50)
        leftBtn.constraintWidthTo(rightBtn)
        
        leftBtn.constraintEdge(.rightToLeft, to: rightBtn, inset: 20)
    }
    
    func testWebsocket() {
        let url = URL(string: "ws://192.168.0.5:8080/channel")!
        let request = URLRequest(url: url)
        websocket = WebSocket(request: request)
        websocket.connect()
        
        websocket.onEvent = { event in
            switch event {
            case .connected(_):
                print("Connected")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.websocket.write(string: "0")
                }
            case .disconnected(_, _):
                print("Disconnected")
            case .text(let message):
                print("Text: \(message)")
            case .binary(_):
                print("Binary")
            case .pong(_):
                print("Pong")
            case .ping(_):
                print("Ping")
            case .error(let error):
                print("Error: \(error?.localizedDescription ?? "unknown")")
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                print("cancelled")
            }
        }
        
        websocket.connect()
        
    }

    @objc func btnHandler(_ sender: UIButton) {
        websocket?.disconnect()
        switch sender {
        case leftBtn:
            sendRequest(direction: "left")
        case rightBtn:
            sendRequest(direction: "right")
        default:
            break
        }
    }
    
    func sendRequest(direction: String) {
        let url = URL(string: "http://192.168.0.5:8080/\(direction)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            let message = String(data: data, encoding: .utf8)!
            print(message)
        }.resume()
    }
}

