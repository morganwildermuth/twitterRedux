//
//  TweetDetailViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/4/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    var tweet: Tweet?

    @IBOutlet weak var contentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.text = tweet?.text!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onReply(sender: AnyObject) {
        performSegueWithIdentifier("segueToPost", sender: nil)
    }

    @IBAction func onFavorite(sender: AnyObject) {
        var tweetArguments = ["id": String(tweet!.id!)]
        TwitterClient.sharedInstance.favoriteWithParams(tweetArguments, completion: {(result, error) -> () in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "Tweet Failed to Favorite", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                    print("\(result)")
                })
            } else {
                let alertController = UIAlertController(title: "Success", message: "Tweet Favorited", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Default, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in })
            }
        })
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithParams(String(tweet!.id!), completion: {(result, error) -> () in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "Tweet Failed to Retweet", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                    print("\(result)")
                })
            } else {
                let alertController = UIAlertController(title: "Success", message: "Tweet Retweeted", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Default, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in })
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToPost"){
            let vc = segue.destinationViewController as! PostViewController
            vc.tweet = self.tweet
            vc.mode = "reply"
        }
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
