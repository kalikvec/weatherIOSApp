import Foundation

import Foundation

public typealias JsonData = Any
public typealias JsonObject = [String:JsonData]
public typealias JsonArray = [JsonObject]

public protocol Mappable {
    associatedtype MappingResult
    
    static func map(response: JsonObject) -> MappingResult?
}

extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
    func value(withKeyPath keyPath: String) -> Any? {
        return (self as NSDictionary).value(forKeyPath: keyPath)
    }    
}

