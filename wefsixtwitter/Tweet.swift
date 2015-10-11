//
//  Tweet.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/4/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: String?
    var createdAtDate: NSDate?
    var dictionary: NSDictionary
    var profileImageUrl: String?
    var id: Int?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        self.id = dictionary["id"] as! Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        profileImageUrl = user!.dictionary["profile_image_url"] as? String
        
        //formatters really expensive, in general use static NSDateFormatter or have property createdAt lazy load for the first time
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAtDate = formatter.dateFromString(createdAtString!)
        formatter.dateFormat = "MMM d HH:mm:ss y"
        createdAt = formatter.stringFromDate(createdAtDate!)
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
