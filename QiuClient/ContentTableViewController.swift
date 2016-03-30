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
    let numPerPage = 4
    var page: Int = 1
    var dataArray = NSMutableArray()
    let refreshCtrl: UIRefreshControl = UIRefreshControl()
    var isRunning = false

    // 如果控制器需要通过xib加载，则需要添加:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "最新"
//        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        loadData()
        
        // 集成刷新控件
        setupRefresh()

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
        
        if isRunning {
            return;
        }
        
        isRunning = true;
        Alamofire.request(QiuHttpRequest.Router.Newest(numPerPage, page).URLRequest).responseJSON() {
            response in
            let error = response.result.error
            let data = response.result.value
            self.isRunning = false
            
            if error == nil {
                
                let arr = (data as! NSDictionary).valueForKey("items") as! NSArray
                for item in arr {
                    self.dataArray.addObject(item);
                }
                self.tableView.reloadData()
                self.page += 1
                
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
        
        if indexPath.row == self.dataArray.count - 1 {
            
            loadData()
        }
        
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
    }

    // 集成下拉刷新
    func setupRefresh() {
        //1.添加刷新控件
        refreshCtrl.addTarget(self, action: "refreshStateChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
    
        //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
        refreshCtrl.beginRefreshing()
    
        // 3.加载数据
        refreshStateChange(refreshCtrl)
    }
    
    // UIRefreshControl进入刷新状态：加载最新的数据
    func refreshStateChange(control: UIRefreshControl) {
        
        loadData()
        tableView.reloadData()
        control.endRefreshing()
    // 3.发送请求
/*    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject){
    
    //1.获取数据，处理数据，传递数据给tableView,如：
    
    // 将最新的微博数据，添加到总数组的最前面
    //        NSRange range = NSMakeRange(0, newStatuses.count);
    //        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
    //        [self.statuses insertObjects:newStatuses atIndexes:set];

    //2.刷新表格
    [self.tableView reloadData];
    
    // 3. 结束刷新
    [control endRefreshing];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    // 结束刷新刷新 ，为了避免网络加载失败，一直显示刷新状态的错误
    [control endRefreshing];
    }]; */
    }

}
