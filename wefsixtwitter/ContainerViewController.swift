//
//  ContainerViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/10/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, TweetsViewControllerDelegate{
    
    @IBOutlet weak var containerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var containerView: UIView!
    var menuCenter: CGPoint?
    var containerViewCenter: CGPoint?
    var selectedViewController: UIViewController?
    var viewControllerIds = ["Profile", "Tweets", "Tweet"]
    

    override func viewWillAppear(animated: Bool) {
        self.view.setNeedsLayout()
        self.containerViewWidthConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 102.0/255, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1)
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[0]), user: nil, tweetsMode: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func selectViewController(viewController: UIViewController, user: User?, tweetsMode: String?){
        if let oldViewController = selectedViewController{
            oldViewController.willMoveToParentViewController(nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
        }
        if let profileUser = user {
            var currentViewController = viewController as? ProfileViewController
            currentViewController!.user = profileUser
        }
        if let mode = tweetsMode {
            var currentViewController = viewController as? TweetsViewController
            currentViewController!.mode = tweetsMode
        }
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedViewController = viewController
        closeMenu()
    }
    
    func tweetsViewControllerOpenUserProfile(tweetCell: TweetTableViewCell) {
        print("lat here")
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[0]), user: tweetCell.tweet?.user, tweetsMode: nil)
    }
    
    func closeMenu(){
        self.view.setNeedsLayout()
        self.containerViewWidthConstraint.constant = 0
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
    }
    @IBAction func onPanRootView(sender: UIPanGestureRecognizer) {
        let panGestureRecognizer = sender
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.view.setNeedsLayout()
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let velocity = sender.velocityInView(sender.view)
            
            if velocity.x > 0.0 {
                self.containerViewWidthConstraint.constant = 300
            } else {
                self.containerViewWidthConstraint.constant = 0
            }
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
        }
    }
    
    @IBAction func onTapProfileButton(sender: AnyObject) {
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[0]), user: nil, tweetsMode: nil)
    }

    @IBAction func onTapTimelineButton(sender: AnyObject) {
        let tweetsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[1]) as? TweetsViewController
        tweetsController!.delegate = self
        self.selectViewController(tweetsController!, user: nil, tweetsMode: nil)
    }
    
    @IBAction func onTapMentionsButton(sender: AnyObject) {
        let tweetsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[1]) as? TweetsViewController
        tweetsController!.delegate = self
        self.selectViewController(tweetsController!, user: nil, tweetsMode: "Mentions")
    }
    
    @IBAction func onTapLogout(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }

    @IBAction func onTapTweet(sender: UIBarButtonItem) {
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[2]), user: nil, tweetsMode: nil)
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
