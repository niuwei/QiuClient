//
//  QiuHttpRequest.swift
//  QiuClient
//
//  Created by niuwei on 16/1/11.
//  Copyright © 2016年 Sina. All rights reserved.
//

import UIKit
import Alamofire

class QiuHttpRequest: NSObject {
    
    enum Router: URLRequestConvertible {
        
        static let baseURLString = "http://m2.qiushibaike.com/article"
        
        case Popular(Int, Int)
        case Newest(Int, Int)
        case Image(Int, Int)
        
        var urlString: String {
            switch self {
            case .Popular(let count, let page):
                return "http://m2.qiushibaike.com/article/list/suggest?count=\(count)&page=\(page)"
            case .Newest(let count, let page):
                return "http://m2.qiushibaike.com/article/list/latest?count=\(count)&page=\(page)"
            case .Image(let count, let page):
                return "http://m2.qiushibaike.com/article/list/imgrank?count=\(count)&page=\(page)"
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            
            let closure = { () -> (path: String, parameters: [String: AnyObject]) in
                
                switch self {
                case .Popular(let count, let page):
                    let params = ["count": "\(count)", "page": "\(page)"]
                    return ("/list/suggest", params)
                case .Newest(let count, let page):
                    let params = ["count": "\(count)", "page": "\(page)"]
                    return ("/list/latest", params)
                case .Image(let count, let page):
                    let params = ["count": "\(count)", "page": "\(page)"]
                    return ("/list/imgrank", params)
                }
            }
            
            let (path, parameters) = closure()
            let url = NSURL(string: Router.baseURLString)
            let urlRequest = NSMutableURLRequest(URL: url!.URLByAppendingPathComponent(path));
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(urlRequest, parameters: parameters).0
        }
        
        func request(completionHandler: (data: AnyObject)->Void) {
            
            let url = NSURL(string: urlString)
            let request = NSURLRequest(URL: url!)
            let queue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: queue) {
                response, data, error in
                if error == nil {
                    let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(data: jsonData)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        print(error)
                        completionHandler(data: NSNull())
                    }
                }
            }
        }
    }
}
