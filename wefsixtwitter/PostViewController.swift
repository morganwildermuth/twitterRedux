//
//  PostViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/4/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postContentTextView: UITextView!
    var mode = "new"
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        postContentTextView.becomeFirstResponder()
        
        postContentTextView.layer.borderWidth = 1
        postContentTextView.layer.cornerRadius = 3
        postContentTextView.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0/255, 136/255, 226/255, 1.0])
        if (mode == "reply"){
            postContentTextView.attributedText = NSAttributedString.init(string: "@\(tweet!.user!.screenname!) ")
            
        } else if (mode == "new") {
            postContentTextView.attributedText = NSAttributedString.init(string: "")
        } else {
            print("no valid mode on Post init")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapTweet(sender: AnyObject) {
        if (mode == "new"){
            sendTweet()
        } else if (mode == "reply"){
            replyToTweet()
        } else {
            print("No valid moe")
        }
    }
    
    private func sendTweet(){
        let statusText = postContentTextView.text
        let tweetArguments = ["status": statusText]
        TwitterClient.sharedInstance.tweetWithParams(tweetArguments, completion: {(result, error) -> () in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "Tweet Failed to Post", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                    print("\(result)")
                })
            } else {
                let alertController = UIAlertController(title: "Success", message: "Tweet Posted", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Default, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                    self.postContentTextView.attributedText = NSAttributedString.init(string: "")
                })
            }
        })
    }
    
    private func replyToTweet(){
        var statusText = postContentTextView.text!
        let tweetArguments = ["status": statusText, "in_reply_to_status_id": String(tweet!.id)]
        TwitterClient.sharedInstance.tweetWithParams(tweetArguments, completion: {(result, error) -> () in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "Tweet Failed to Post", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                    print("\(result)")
                })
            } else {
                let alertController = UIAlertController(title: "Success", message: "Tweet Posted", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Exit", style: .Default, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in })
            }
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
