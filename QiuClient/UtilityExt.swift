//
//  UtilityExt.swift
//  QiuClient
//
//  Created by niuwei on 16/1/13.
//  Copyright © 2016年 Sina. All rights reserved.
//
import UIKit
import Foundation

extension NSDictionary {
    
    func stringAttributeForKey(key: String) -> String {
        
        let obj: AnyObject? = self[key]
        if let value = obj {
            if let _ = obj as? NSObject {
                if value.isKindOfClass(NSNumber) {
                    let num = value as! NSNumber
                    return num.stringValue
                } else if let str = value as? String {
                    return str
                }
            }
        }
        return ""
    }
}

extension String {
    
    
    func stringHeightWith(fontSize:CGFloat, width:CGFloat)->CGFloat
    {
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width,CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
    func dateStringFromTimestamp(timeStamp:NSString)->String
    {
        let ts = timeStamp.doubleValue
        let  formatter = NSDateFormatter ()
        formatter.dateFormat = "yyyy年MM月dd日 HH:MM:ss"
        let date = NSDate(timeIntervalSince1970 : ts)
        return  formatter.stringFromDate(date)
    }
}

extension UIView  {
    
    func x()->CGFloat
    {
        return self.frame.origin.x
    }
    func right()-> CGFloat
    {
        return self.frame.origin.x + self.frame.size.width
    }
    func y()->CGFloat
    {
        return self.frame.origin.y
    }
    func bottom()->CGFloat
    {
        return self.frame.origin.y + self.frame.size.height
    }
    func width()->CGFloat
    {
        return self.frame.size.width
    }
    func height()-> CGFloat
    {
        return self.frame.size.height
    }
    
    func setX(x: CGFloat)
    {
        var rect:CGRect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func setRight(right: CGFloat)
    {
        var rect:CGRect = self.frame
        rect.origin.x = right - rect.size.width
        self.frame = rect
    }
    
    func setY(y: CGFloat)
    {
        var rect:CGRect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    func setBottom(bottom: CGFloat)
    {
        var rect:CGRect = self.frame
        rect.origin.y = bottom - rect.size.height
        self.frame = rect
    }
    
    func setWidth(width: CGFloat)
    {
        var rect:CGRect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func setHeight(height: CGFloat)
    {
        var rect:CGRect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    class func showAlertView(title:String,message:String)
    {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("好")
        alert.show()
    }
}

extension UIImageView
{
    func setImage(urlString:String,placeHolder:UIImage!)
    {
        
        let url = NSURL(string: urlString)
        let cacheFilename = url!.lastPathComponent
        let cachePath = FileUtility.cachePath(cacheFilename!)
        let image : AnyObject = FileUtility.imageDataFromPath(cachePath)
        //  println(cachePath)
        if image as! NSObject != NSNull()
        {
            self.image = image as? UIImage
        }
        else
        {
            let req = NSURLRequest(URL: url!)
            let queue = NSOperationQueue();
            NSURLConnection.sendAsynchronousRequest(req, queue: queue, completionHandler: { response, data, error in
                if (error != nil)
                {
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            print(error)
                            self.image = placeHolder
                    })
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            
                            let image = UIImage(data: data!)
                            if (image == nil)
                            {
                                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                                
                                if let _:String? = jsonData["error"] as? String {
                                    //println("\(err)")
                                    print("url fail=\(urlString)");
                                }
                                //println("img is nil,path=\(cachePath)")
                                self.image = placeHolder
                            }
                            else
                            {
                                self.image = image
                                let bIsSuccess = FileUtility.imageCacheToPath(cachePath,image:data!)
                                if !bIsSuccess
                                {
                                    print("*******cache fail,path=\(cachePath)")
                                }
                            }
                    })
                }
            })
            
        }
        
    }
}