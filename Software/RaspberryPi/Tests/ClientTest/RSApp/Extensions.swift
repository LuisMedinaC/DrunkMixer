//
//  Extensions.swift
//  
//
//  Created by Aldo Fuentes on 25/09/19.
//  Copyright © 2019 Softtek. All rights reserved.
//

import UIKit
import Combine

extension UIButton {
    
    func setText(_ text: String, color: UIColor, font: String, size: CGFloat, alignment: NSTextAlignment = .center){
        self.setTitle(text, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = UIFont(name: font, size: size)
        self.titleLabel?.textAlignment = alignment
    }
    
    
    func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}


extension UILabel {
    
    func setText(_ text: String, color: UIColor = UIColor.black, font: String, size: CGFloat = 10.0, alignment: NSTextAlignment = .center){
        self.font = UIFont(name: font, size: size)
        self.textColor = color
        self.text = text
        self.textAlignment = alignment
    }
    
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
}



extension UITextField {
    
    func applyShadow(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    func setBottomBorder(color: UIColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func removeBottomBorder(){
        self.layer.shadowOffset = CGSize.zero
    }
    func setLeftPadding(_ x: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: x, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

public enum FileIconSize {
    case smallest
    case largest
}

extension UIImage {
    func changeColor(to color : UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    public class func icon(forFileURL fileURL: URL, preferredSize: FileIconSize = .smallest) -> UIImage {
        let myInteractionController = UIDocumentInteractionController(url: fileURL)
        let allIcons = myInteractionController.icons
        
        // allIcons is guaranteed to have at least one image
        switch preferredSize {
        case .smallest: return allIcons.first!
        case .largest: return allIcons.last!
        }
    }
    
    public class func icon(forFileNamed fileName: String, preferredSize: FileIconSize = .smallest) -> UIImage {
        return icon(forFileURL: URL(fileURLWithPath: fileName), preferredSize: preferredSize)
    }
    
    public class func icon(forPathExtension pathExtension: String, preferredSize: FileIconSize = .smallest) -> UIImage {
        let baseName = "Generic"
        let fileName = (baseName as NSString).appendingPathExtension(pathExtension) ?? baseName
        return icon(forFileNamed: fileName, preferredSize: preferredSize)
    }
    
    func resizeImage(toSize newSize: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(origin: .zero, size: newSize))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
}

extension UIView {
    
    var maxVal: CGFloat! { return max(self.frame.height, self.frame.width)}
    var minVal: CGFloat! { return min(self.frame.height, self.frame.width)}
    
    func removeSubviews(){
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
    
    func isOutOfBounds() -> Bool! {
        guard let superView = self.superview else {
            return nil
        }
        return !superView.bounds.intersection(self.frame).equalTo(self.frame)
    }
    
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    func snapshot(withRect rect: CGRect) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func snapshot(withSize size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: currentContext)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func setBorder(width : CGFloat, color : UIColor, cornerRadius: CGFloat = 0.0){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    func innerShadow(radius: CGFloat, opacity: CGFloat){
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(opacity), UIColor.clear]
        layer.shadowRadius = radius
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: radius)
        
        self.layer.addSublayer(layer)
        
    }
    func applyShadow(r: CGFloat = 8, o: Float = 0.2, offset: CGSize = CGSize(width: 0, height: 2)){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = r
        self.layer.shadowOpacity = o
        self.layer.shadowOffset = offset
    }
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Aceptar", style: .done, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

extension UIViewController {
    
    var shadowLine: UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.applyShadow(r: 0.5, o: 0.65)
        view.constraintHeightTo(constant: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setBottomShadow() {
        let shadowView = shadowLine
        view.addSubview(shadowView)
        shadowView.constraintTo(view, attributes: [.bottom, .left, .right], insets: UIEdgeInsets(0, -1))
    }
    
    func createAlert(title: String?, message: String?, dismissAutomatically: Bool = false) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if dismissAutomatically {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    func errorAlert(title: String = "Error", error: NSError?){
        let defaultMessage = "Try again later"
        let errorMessage = error?.userInfo["error"] as? String
        self.createAlert(title: title, message: errorMessage ?? defaultMessage)
    }
//    func swapRootViewControllerTo(_ destinationVC: UIViewController){
//        let rootVC = UIApplication.shared.keyWindow!.rootViewController!
//        let rootView = rootVC.view!
//        let destinationView = destinationVC.view!
//        
//        let snapshot = destinationView.snapshotView(afterScreenUpdates: true)!
//        snapshot.frame.origin = CGPoint(x: rootView.frame.width, y: 0)
//        rootView.addSubview(snapshot)
//
//
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//            rootView.frame.origin = CGPoint(x: -rootView.frame.width, y: 0)
//        }, completion: { _ in
//            UIApplication.shared.keyWindow?.rootViewController = destinationVC
//            UIApplication.shared.keyWindow?.makeKeyAndVisible()
//            snapshot.removeFromSuperview()
//            self.dismiss(animated: false) {
//                self.parent?.dismiss(animated: false, completion: {
//                    return
//                })
//            }
//        })
//        
//    }
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func clearNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navBar.shadowImage = UIImage()
    }
    
    func restoreNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.setBackgroundImage(nil, for: .any, barMetrics: .default)
        navBar.shadowImage = nil
        navBar.barTintColor = nil
    }
    
//    func setStatusBarStyle(_ style: UIStatusBarStyle) {
//        if let navController = navigationController as? NavigationViewController {
//            navController.statusBarStyle = style
//        }
//    }
    
    func setNavigationTitleColor(_ color: UIColor) {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = color
        navBar.titleTextAttributes = [.foregroundColor: color]
    }
    
    func setBackButtonTitle(_ title: String) {
        let btn = UIBarButtonItem()
        btn.title = title
        navigationItem.backBarButtonItem = btn
    }
}

extension Date{
    init?(date: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: NSLocale.current.identifier)
        guard let formattedDate = formatter.date(from: date) else { return nil }
        self.init(timeInterval: 0, since: formattedDate)
    }
    init?(date: String, style: DateFormatter.Style) {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.locale = Locale(identifier: NSLocale.current.identifier)
        guard let formattedDate = formatter.date(from: date) else { return nil }
        self.init(timeInterval: 0, since: formattedDate)
    }
    
    static var customDateFormatt: String {
        return  "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    func customDate() -> String {
        let format = DateFormatter(dateFormat: Date.customDateFormatt)
        return format.string(from: self)
    }
    
    func string(format: String) -> String {
        let format = DateFormatter(dateFormat: format)
        return format.string(from: self)
    }
    
    func getTimeUnit() -> TimeUnit {
        let minutes = secondsSinceNow / 60
        if minutes < 60 { return .minute }
        let hours = minutes / 60
        if hours < 24 { return .hour }
        let days = hours / 24
        if days < 7 { return .day }
        return .week
    }
    
    var secondsSinceNow: Double { return (timeIntervalSinceNow * -1) }
    
    func timeSinceNowText() -> String {
        let timeInterval = getTimeUnit()
        let time = secondsSinceNow / timeInterval.rawValue
        let roundTime = Int(time)
        if roundTime == 0 {
            return "now"
        }
        var timeStr = String(roundTime)
        timeStr.append(" ")
        timeStr.append(timeInterval.suffix)
        return timeStr
    }
    
    enum TimeUnit: Double {
        case minute = 60
        case hour = 3600
        case day = 86400
        case week = 604800
        
        var suffix: String {
            switch self {
            case .minute:
                return "m"
            case .hour:
                return "hr"
            case .day:
                return "d"
            case .week:
                return "w"
            }
        }
    }
}

extension DateFormatter{
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
    convenience init(style: DateFormatter.Style){
        self.init()
        self.dateStyle = style
    }
}

extension JSONDecoder{
    func decodeNormal<T>(_ type: T.Type, from object: Any) throws -> T where T: Decodable{
        let data = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        return try decode(type, from: data)
    }
}

extension String {
    func capitalizeFirst() -> String {
        guard self.count > 1 else{ return self}
        return String(self.first!).capitalized + self.dropFirst().lowercased()
    }
    
    func convertHtml() -> NSAttributedString {
        let data = Data(self.utf8)
        let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attributedString ?? NSAttributedString()
    }
    
    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    
    func slice(matching regex: String) -> String? {
        range(of: regex, options: .regularExpression).flatMap({ String(self[$0]) })
    }
}

extension Double {
    func truncate(_ places: Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
    -> Dictionary<K,V>
{
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

extension URLRequest{
    init?(url: String, parameters: [String: String]){
        guard var components = URLComponents(string: url) else{ return nil}
        components.queryItems = parameters.map{ URLQueryItem(name: $0.0, value: $0.1) }
        guard let url = components.url else{ return nil }
        self.init(url: url)
    }
}

extension URLSession{
    
    func getData<T: Decodable>(with url: String, parameters: [String: String] = [:], completion: @escaping (T?)->()){
        guard var request = URLRequest(url: url, parameters: parameters) else{ completion(nil); return }
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else{
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let decoder = JSONDecoder()
            let ideas = try? decoder.decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(ideas)
            }
            
            }.resume()
    }
}

extension UIView{
    func border(){
        layer.borderWidth = 1
    }
}

extension UIButton{
    func setText(_ text: String, color: UIColor, font: UIFont, alignment: NSTextAlignment = .center){
        self.setTitle(text, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.titleLabel?.textAlignment = alignment
    }
}


func +(lhs: String?, rhs: String?) -> String? {
    
    if let lhs = lhs {
        if let rhs = rhs {
            return lhs + rhs
        } else {
            return lhs
        }
    }
    
    if let rhs = rhs {
        return rhs
    }
    
    return nil
    
}

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
       sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}

extension Publisher where Self.Failure == Never {
public func weakAssign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
    sink { [weak object] (value) in
        object?[keyPath: keyPath] = value
    }
  }
}
