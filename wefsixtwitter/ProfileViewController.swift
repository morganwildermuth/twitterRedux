//
//  ProfileViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/10/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.currentUser
        setOutletValues()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setOutletValues(){
        let tweetCount = user?.tweetCount!
        let followingCount = user?.followingCount!
        let followersCount = user?.followersCount!
        tweetsLabel.text = String(tweetCount!)
        followingLabel.text = String(followingCount!)
        followersLabel.text = String(followersCount!)
        setHeaderImageView()
        setProfileImage()
        
//        var profileBackgroundImageUrl: String?
    }
    
    func setHeaderImageView(){
        let imageUrl = user?.profileBannerImageUrl
        let url_request = NSURLRequest(URL: NSURL(string: imageUrl!)!)
        let placeholder = UIImage(named: "no_photo")
        
        headerImageView.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: { (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
            if let image = image {
                self.headerImageView.image = image;
            }
            }, failure: {(request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                self.headerImageView.image = placeholder
        })
    }
    
    func setProfileImage(){
        let imageUrl = user?.profileImageUrl
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
