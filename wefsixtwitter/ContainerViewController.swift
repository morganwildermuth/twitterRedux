//
//  ContainerViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/10/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var containerView: UIView!
    var menuCenter: CGPoint?
    var containerViewCenter: CGPoint?
    let tweetsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tweets")
    let mentionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Mentions")
    
    var selectedViewController: UIViewController?
    var viewControllerIds = ["Profile", "Tweets", "Mentions"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 102.0/255, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1)
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[2]))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectViewController(viewController: UIViewController){
        if let oldViewController = selectedViewController{
            oldViewController.willMoveToParentViewController(nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
        }
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedViewController = viewController
    }
    
    @IBAction func onPanContainerView(sender: AnyObject) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        
        let panGestureRecognizer = sender
//        let point = panGestureRecognizer.locationInView(sender.view?.superview)
//        let translation = panGestureRecognizer.translationInView(sender.superview)
//
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            // menu
            // y starts at 400
            // x starts at 23.5
            //container
            // y starts at 400
            // x starts at 230.5
            
            menuCenter = menuView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let velocity = sender.velocityInView(sender.view)
            var currentMenuCenter: CGFloat
            var currentContainerCenter: CGFloat
            
            if velocity.x > 0.0 {
                print("velocity was above 0")
                currentMenuCenter = CGFloat(30.0)
                currentContainerCenter = CGFloat(237.0)
            } else {
                print("velocity was below 0")
                currentMenuCenter = CGFloat(23.5)
                currentContainerCenter = CGFloat(230.5)
            }
            
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.menuView.center = CGPoint(x: currentMenuCenter, y: self.menuCenter!.y)
                }, completion: { (Bool) -> Void in })
            
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.containerView.center = CGPoint(x: currentContainerCenter, y: self.menuCenter!.y)
                }, completion: { (Bool) -> Void in })
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
        }
    }
        
    @IBAction func onTapProfileButton(sender: AnyObject) {
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[0]))
    }

    @IBAction func onTapTimelineButton(sender: AnyObject) {
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[1]))
    }
    
    @IBAction func onTapMentionsButton(sender: AnyObject) {
        self.selectViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIds[2]))
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
