//
//  TweetTableViewCell.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/4/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit
@objc protocol TweetTableViewCellDelegate {
    optional func tweetTableViewCellOpenUserProfile(tweetCell: TweetTableViewCell)
    optional func tweetTableViewCellSegueToPost(tweetCell: TweetTableViewCell)
    // too late and tired to implement, but the below is a good idea since then I can do the wee alerts like before
//    optional func favoriteTweetTableViewCell(tweetCell: TweetTableViewCell)
//    optional func replyTweetTableViewCell(tweetCell: TweetTableViewCell)
    
}

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet?

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    weak var delegate: TweetTableViewCellDelegate?


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

    @IBAction func onTapUserImage(sender: AnyObject) {
       //we want to say, hey, you, ContainerViewController, handle this specific selectViewController
        delegate?.tweetTableViewCellOpenUserProfile?(self)
    }
    
    
    @IBAction func onFavoriteTap(sender: AnyObject) {
        var tweetArguments = ["id": String(tweet!.id!)]
        TwitterClient.sharedInstance.favoriteWithParams(tweetArguments, completion: {(result, error) -> () in
            if error != nil {
                print("fav fail")
            } else {
                print("fav success)")
            }
        })
    }
    
    @IBAction func onReplyTap(sender: AnyObject) {
        delegate?.tweetTableViewCellSegueToPost?(self)
    }
    
    @IBAction func onRetweetTap(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithParams(String(tweet!.id!), completion: {(result, error) -> () in
            if error != nil {
                print("retweet fail")
            } else {
                print("retweet success")
            }
        })
    }
    
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
