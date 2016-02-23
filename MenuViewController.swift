//
//  MenuViewController.swift
//

import UIKit

class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var viewController: UIViewController!

    var menus = ["サインイン", "ヘルプ"]
    var images = ["add-user-512.png", "44791070"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menutableCell", forIndexPath: indexPath)

        let menuimage = tableView.viewWithTag(1) as! UIImageView
        menuimage.image = UIImage(named: images[indexPath.row])

        let menulabel = tableView.viewWithTag(2) as! UILabel
        menulabel.text = menus[indexPath.row]

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}