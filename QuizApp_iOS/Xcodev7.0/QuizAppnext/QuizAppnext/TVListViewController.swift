//
//  TVListViewController.swift
//  QuizApp
//
//  Created by Ankita on 8/13/15.
//  Copyright (c) 2015 Ankita. All rights reserved.
//

import Foundation
import UIKit
import SmartView

class TVListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var didFindServiceObserver: AnyObject? = nil
    var didRemoveServiceObserver: AnyObject? = nil
    
    var selectedTVName:String?
    
    @IBOutlet weak var allTVNetworkView: UITableView!
    
    let activityIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        
        

        allTVNetworkView.delegate = self
        allTVNetworkView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(TVListViewController.channelConnected(_:)), name: NSNotification.Name(rawValue: "channelGetsConnected"), object: nil)
        
        self.navigationItem.title = "Quiz App"
        
        
        activityIndicatorView.frame = CGRect(x: 50, y: 300, width: 10, height: 10)
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom)
        buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        buttonBack.setImage(UIImage(named:"backImage.png"), for:UIControlState())
        buttonBack.addTarget(self, action: #selector(TVListViewController.leftNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let buttonRefresh: UIButton = UIButton(type: UIButtonType.custom)
        buttonRefresh.frame = CGRect(x: 300, y: 5, width: 30, height: 30)
        buttonRefresh.setImage(UIImage(named:"refresh_Image.png"), for:UIControlState())
        buttonRefresh.addTarget(self, action: #selector(TVListViewController.rightNavButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        allTVNetworkView.backgroundView = UIImageView(image: UIImage(named:"back1.jpg"))
    }
    
    func leftNavButtonClick(_ sender:UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
        
       // ShareController.sharedInstance.disconnect()
    }
    
    func rightNavButtonClick(_ sender:UIButton!)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
//        ShareController.sharedInstance.searchServices()
        
        didFindServiceObserver =  ShareController.sharedInstance.search.on(MSDidFindService) { [unowned self] notification in
            self.allTVNetworkView.reloadData()
        }
        
        didRemoveServiceObserver = ShareController.sharedInstance.search.on(MSDidRemoveService) {[unowned self] notification in
            self.allTVNetworkView.reloadData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ShareController.sharedInstance.search.off(didFindServiceObserver!)
        ShareController.sharedInstance.search.off(didRemoveServiceObserver!)
       // ShareController.sharedInstance.clearServices()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if ShareController.sharedInstance.search.isSearching {
        //            return ShareController.sharedInstance.services.count
        //        } else {
        //            return 1
        //        }
        NSLog("count is %d", ShareController.sharedInstance.services.count)
        
        return ShareController.sharedInstance.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("table view cell for row at")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        cell.textLabel?.text = ShareController.sharedInstance.services[indexPath.row].name
        cell.textLabel?.textColor = UIColor.orange
        cell.backgroundView = UIImageView(image: UIImage(named:"back1.jpg"))
        selectedTVName = ShareController.sharedInstance.services[indexPath.row].name

        cell.backgroundColor = UIColor(patternImage: UIImage(named: "back1.jpg")!)
        NSLog("Hello %@!", ShareController.sharedInstance.services[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Connect to TV"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (ShareController.sharedInstance.search.isSearching)
        {
            ShareController.sharedInstance.launchApp("quizApp.17", index: indexPath.row)
            
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func channelConnected(_ notification: Notification!) {
        
        self.activityIndicatorView.stopAnimating()
        ShareController.sharedInstance.clearServices()
        self.allTVNetworkView.reloadData()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let playerTypeViewController = storyBoard.instantiateViewController(withIdentifier: "PlayerTypeView") as! PlayerTypeViewController
        self.navigationController?.pushViewController(playerTypeViewController, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }

}
