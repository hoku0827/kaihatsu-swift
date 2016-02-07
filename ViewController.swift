//
//  ViewController.swift
//  APIDemo
//
//  Created by Kazuya Tateishi on 2015/03/25.
//  Copyright (c) 2015年 kzy52. All rights reserved.
//

import UIKit
import Alamofire

// UITableViewを使用する際はUITableViewDataSourceプロトコルとUITableViewDelegateプロトコルを実装する必要がある
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table:UITableView!
    let imgArray: NSArray = ["img1.jpg", "img2.jpg", "img3.jpg", "img4.jpg", "img5.jpg"]
    let cellId = "tableCell"
    
    // 今回はテーブル表示にしたいので UITableView を使う
    var tableView : UITableView?
    
    var users = UserDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.request()
    }
    
    // セルの総数を返す(表示するテーブルの行数)
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    // 表示するセルを生成して返す
    // UITableViewDataSource を使う場合は 必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // UITableViewCellはテーブルの一つ一つのセルを管理するクラス。
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
        
        // Cellに値を設定する.
        let user: User = self.users[indexPath.row] as User
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    // Web API をコールする
    func request() {
        Alamofire.request(Router.GetUsers()).responseJSON { response in
            if let json = response.result.value as? Array<Dictionary<String,AnyObject>> {
                for j in json {
                    let user: User = User(
                        email: j["email"] as! String
                    )
                    self.users.set(user)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}