//
//  ContentCell.swift
//  QiuClient
//
//  Created by niuwei on 16/1/13.
//  Copyright © 2016年 Sina. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    var data: NSDictionary!
    @IBOutlet var nickLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.data != nil else { return }
        
        if let userDict = self.data["user"] as? NSDictionary {
            self.nickLabel.text = userDict["login"] as? String
            if let userIcon = userDict["icon"] as? String {
                let userId: String = userDict.stringAttributeForKey("id")
                if !userId.isEmpty {
                    let prefixUserId = userId.substringToIndex(userId.endIndex.advancedBy(-4))
                    let userImageURL = "http://pic.qiushibaike.com/system/avtnew/\(prefixUserId)/\(userId)/medium/\(userIcon)"
                    self.avatarView.setImage(userImageURL, placeHolder: UIImage(named: "avatar"))
                }
            }
            
        }
        
        // content label
        let content = self.data.stringAttributeForKey("content")
        let height = content.stringHeightWith(17, width:300)
        self.contentLabel.setHeight(height)
        self.contentLabel.text = content

    }

}
