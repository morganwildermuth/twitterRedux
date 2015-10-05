//
//  TweetTableViewCell.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/4/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet?

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // does not seem to be best practices to use init here...?
    // thought perhaps a computed property for tweet that would then set these during the get
    
    func setData(){
        userLabel.text = tweet?.user?.name
        contentLabel.text = tweet?.text
        createdAtLabel.text = tweet?.createdAt!
        setProfileImage()
    }
    
    func setProfileImage(){
        let imageUrl = tweet?.profileImageUrl
        let url_request = NSURLRequest(URL: NSURL(string: imageUrl!)!)
        let placeholder = UIImage(named: "no_photo")
        
        userImage.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: { (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
            if let image = image {
                self.userImage.image = image;
            }
            }, failure: {(request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                self.userImage.image = nil
            })
    }
}
