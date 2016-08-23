//
//  Path.swift
//  SwiftPhoenix
//
//  Created by Kyle Oba on 8/23/15.
//  Copyright (c) 2015 David Stump. All rights reserved.
//

import Foundation

public struct Path {
    
    /**
     Reomoves trailing slash from URL string
     
     - parameter path: String path
     
     - returns: String
     */
    public static func removeTrailingSlash(_ path:String) -> String {
        if path.characters.count == 0 { return path }
        if path.characters.last! == "/" {
            return path.substring(with: (path.startIndex ..< path.characters.index(path.endIndex, offsetBy: -1)))
        }
        return path
    }
    
    /**
     Remove Leading Slash from URL string
     
     - parameter path: String path
     
     - returns: String
     */
    public static func removeLeadingSlash(_ path:String) -> String {
        if path.characters.count == 0 { return path }
        if path.substring(with: (path.startIndex ..< path.characters.index(path.startIndex, offsetBy: 1))) == "/" {
            
            let idx = path.characters.index(path.characters.startIndex, offsetBy: 1)
            let substring = path.characters.indices.suffix(from: idx)
            
            return path.substring(with: idx..<path.characters.endIndex)
        }
        return path
    }
    
    /**
     Remove both leading and trailing URL slashes
     
     - parameter path: String path
     
     - returns: String
     */
    public static func removeLeadingAndTrailingSlashes(_ path:String) -> String {
        return Path.removeTrailingSlash( Path.removeLeadingSlash(path) )
    }
    
    
    public static func encodeQuery(_ string:String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    /**
     Build the Query Params
     
     - parameter path: Dict
     
     - returns: String
     */
    public static func buildQueryParams(_ query:[String:String]) -> String {
        if query.count == 0 { return "" }
        return "?" + query.map({ $0.0 + "=" + encodeQuery($0.1) }).joined(separator: "&").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    /**
     Builds proper endoint
     
     - parameter prot:          Endpoint protocol - usually 'ws'
     - parameter domainAndPort: Phoenix server root domain and port
     - parameter path:          Phoenix server socket path
     - parameter transport:     Server transport - usually "websocket"
     
     - returns: String
     */
    public static func endpointWithProtocol(_ prot:String, domainAndPort:String, path:String, query:[String:String] = [:], transport:String) -> String {
        var theProt = ""
        switch prot {
        case "ws":
            theProt = "http"
        case "wss":
            theProt = "https"
        default:
            theProt = prot
        }
        
        let theDomAndPort = removeLeadingAndTrailingSlashes(domainAndPort)
        let thePath = removeLeadingAndTrailingSlashes(path)
        let theQuery = buildQueryParams(query)
        let theTransport = removeLeadingAndTrailingSlashes(transport)
        return "\(theProt)://\(theDomAndPort)/\(thePath)/\(theTransport)\(theQuery)"
    }
}
