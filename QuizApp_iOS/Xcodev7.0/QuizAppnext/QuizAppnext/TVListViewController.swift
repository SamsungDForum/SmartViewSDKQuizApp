//
//  TVListViewController.swift
//  QuizApp
//
//  Created by Ankita on 8/13/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit
import MSF

class TVListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var didFindServiceObserver: AnyObject? = nil
    var didRemoveServiceObserver: AnyObject? = nil
    
    var selectedTVName:String?
    
    @IBOutlet weak var allTVNetworkView: UITableView!
    
    let activityIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
        

        allTVNetworkView.delegate = self
        allTVNetworkView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "channelConnected:", name: "channelGetsConnected", object: nil)
        
        self.navigationItem.title = "Quiz App"
        
        
        activityIndicatorView.frame = CGRectMake(50, 300, 10, 10)
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        buttonBack.frame = CGRectMake(5, 5, 30, 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), forState:UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonRefresh: UIButton = UIButton(type: UIButtonType.Custom)
        buttonRefresh.frame = CGRectMake(300, 5, 30, 30)
        buttonRefresh.setImage(UIImage(named:"refresh_Image.png"), forState:UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "rightNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
        
        
        
       allTVNetworkView.backgroundView = UIImageView(image: UIImage(named:"back1.jpg"))
    }
    
    func leftNavButtonClick(sender:UIButton!)
    {
        self.navigationController?.popViewControllerAnimated(true)
        
       // ShareController.sharedInstance.disconnect()
    }
    
    func rightNavButtonClick(sender:UIButton!)
    {
        if (ShareController.sharedInstance.services.count != 0)
        {
            ShareController.sharedInstance.stopSearch(1)
        }
        else
        {
            ShareController.sharedInstance.searchServices()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //ShareController.sharedInstance.searchServices()
        
        didFindServiceObserver =  ShareController.sharedInstance.search.on(MSDidFindService) { [unowned self] notification in
            self.allTVNetworkView.reloadData()
        }
        
        didRemoveServiceObserver = ShareController.sharedInstance.search.on(MSDidRemoveService) {[unowned self] notification in
            self.allTVNetworkView.reloadData()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        ShareController.sharedInstance.search.off(didFindServiceObserver!)
        ShareController.sharedInstance.search.off(didRemoveServiceObserver!)
       // ShareController.sharedInstance.clearServices()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if ShareController.sharedInstance.search.isSearching {
        //            return ShareController.sharedInstance.services.count
        //        } else {
        //            return 1
        //        }
        NSLog("count is %d", ShareController.sharedInstance.services.count)
        
        return ShareController.sharedInstance.services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell", forIndexPath: indexPath) 
        cell.backgroundView = UIImageView(image: UIImage(named:"back1.jpg"))
        cell.textLabel?.text = ShareController.sharedInstance.services[indexPath.row].name
        cell.textLabel?.textColor = UIColor.orangeColor()

        cell.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        selectedTVName = ShareController.sharedInstance.services[indexPath.row].name
                NSLog("Hello %@!", ShareController.sharedInstance.services[indexPath.row].name)
        
       
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Connect to TV"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (ShareController.sharedInstance.search.isSearching)
        {
            ShareController.sharedInstance.launchApp("quizApp", index: indexPath.row)
            
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func channelConnected(notification: NSNotification!) {
        
        self.activityIndicatorView.stopAnimating()
        ShareController.sharedInstance.clearServices()
        self.allTVNetworkView.reloadData()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let playerTypeViewController = storyBoard.instantiateViewControllerWithIdentifier("PlayerTypeView") as! PlayerTypeViewController
        self.navigationController?.pushViewController(playerTypeViewController, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }

}