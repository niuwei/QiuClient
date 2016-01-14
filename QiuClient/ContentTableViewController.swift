//
//  ContentTableViewController.swift
//  QiuClient
//
//  Created by niuwei on 16/1/11.
//  Copyright © 2016年 Sina. All rights reserved.
//

import UIKit
import Alamofire



class ContentTableViewController: UITableViewController {

    let identifier = "reuseIdentifier"
    var page: Int = 1
    var dataArray = NSMutableArray()

    // 如果控制器需要通过xib加载，则需要添加:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "最新"
//        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func setupView() {
        
        let nib = UINib(nibName:"ContentCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: identifier)
    }
    
    func loadData() {
        
        Alamofire.request(QiuHttpRequest.Router.Newest(20, page).URLRequest).responseJSON() {
            response in
            let error = response.result.error
            let data = response.result.value
            
            if error == nil {
                
                let arr = (data as! NSDictionary).valueForKey("items") as! NSArray
                for item in arr {
                    self.dataArray.addObject(item);
                }
                self.tableView.reloadData()
                
            } else {
                let alert = UIAlertView()
                alert.title = "提示"
                alert.message = "加载失败"
                alert.addButtonWithTitle("好")
                alert.show()
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? ContentCell
        let index = indexPath.row
        let data = self.dataArray[index] as! NSDictionary
        cell!.data = data
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
