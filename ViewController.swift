//
//  ViewController.swift
//

import UIKit
import Alamofire

// UITableViewを使用する際はUITableViewDataSourceプロトコルとUITableViewDelegateプロトコルを実装する必要がある
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table:UITableView!
    
    let imgArray: NSArray = ["img1.jpg", "img2.jpg", "img3.jpg", "img4.jpg", "img5.jpg", "img6.jpg", "img7.jpg", "img8.jpg"]
    let cellId = "tableCell"
    
    // 今回はテーブル表示にしたいので UITableView を使う
    var tableView : UITableView?
    
    var users = UserDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        // request for CMS
        self.request()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    // セルの総数を返す(表示するテーブルの行数)
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.size
    }
    
    // 表示するセルを生成して返す
    // UITableViewDataSource を使う場合は 必須
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // UITableViewCellはテーブルの一つ一つのセルを管理するクラス。    
        let cell = table.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)

        let img = UIImage(named:"\(imgArray[indexPath.row])")
        
        let imageView = table.viewWithTag(1) as! UIImageView
        imageView.image = img

        let leadLabel = table.viewWithTag(2) as! UILabel
        leadLabel.text = "AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCC"
        leadLabel.numberOfLines = 0
        leadLabel.sizeToFit()

        let accountLabel = table.viewWithTag(3) as! UILabel
        let user: User = self.users[indexPath.row] as User
        accountLabel.text = user.email
        
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
                    self.table!.reloadData()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}