//
//  ViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/3/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        loginImageView.image = UIImage(named: "twitter-128")
        loginImageView.userInteractionEnabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        //could do User.login(completion) that calls this thing below
        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                //perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                //handle login error
            }
        }
    }

}

