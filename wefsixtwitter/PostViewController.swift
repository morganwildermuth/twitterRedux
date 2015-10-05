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
    override func viewDidLoad() {
        super.viewDidLoad()
        postContentTextView.becomeFirstResponder()
        postContentTextView.attributedText = NSAttributedString.init(string: "")
        postContentTextView.layer.borderWidth = 1
        postContentTextView.layer.cornerRadius = 3
        postContentTextView.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0/255, 136/255, 226/255, 1.0])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapTweet(sender: AnyObject) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
