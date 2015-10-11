//
//  ContainerViewController.swift
//  wefsixtwitter
//
//  Created by Morgan Wildermuth on 10/10/15.
//  Copyright © 2015 WEF6. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    let tweetsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tweets")
    let mentionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Mentions")
    
    var selectedViewController: UIViewController?
    
    //includes profile, timeline, mentions
//    var mentionsViewController =  UIStoryboard(name: "mentionsViewController", bundle: nil).instantiateViewControllerWithIdentifier("MentionsViewController") as! MentionsViewController
    
//    let viewController = [
//        ProfileViewController(nibName: nil, bundle: nil),
//        TweetsViewController(nibName: nil, bundle: nil),
//        MentionsViewController(nibName: nil, bundle: nil)
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectViewController(mentionsVC)
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
        print(viewController)
        print(viewController.view)
        print(viewController.view.frame)
        print("after frame")
        print(self)
        print(self.containerView)
        print(self.containerView.bounds)
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedViewController = viewController
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
