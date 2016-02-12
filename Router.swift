//
//  Router.swift
//  APIDemo
//
//  Created by Kazuya Tateishi on 2015/03/25.
//  Copyright (c) 2015年 kzy52. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://ec2-52-68-185-145.ap-northeast-1.compute.amazonaws.com"
    
    case GetUsers()
    
    var URLRequest: NSMutableURLRequest {
        
        let (method, path, parameters): (Alamofire.Method, String, [String: AnyObject]?) = {
            switch self {
            case .GetUsers: return (.GET, "/api/v1/users", nil)
            }
        }()

        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(path))
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}