//
//  ViewController.swift
//

import UIKit
import Alamofire

// UITableViewを使用する際はUITableViewDataSourceプロトコルとUITableViewDelegateプロトコルを実装する必要がある
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table:UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var cfgBtn: UIButton!
    
    let cellId = "tableCell"
    
    // 今回はテーブル表示にしたいので UITableView を使う
    var tableView : UITableView?
    var selectedUrl: NSURL?
    var articles = ArticleDataManager.sharedInstance

    // メニュー表示
    func tappedLeftBarButton() {
        self.slideMenuController()?.openLeft()
    }
    
    // 検索画面を表示
    func searchButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sVC = storyboard.instantiateViewControllerWithIdentifier("SearchViewController")
        navigationController?.pushViewController(sVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button string
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem

        // create menu button
        menuBtn.setImage(UIImage(named: "ic_menu_black_24dp"), forState: UIControlState.Normal)
        menuBtn.addTarget(self, action: "tappedLeftBarButton", forControlEvents: UIControlEvents.TouchUpInside)
        let menuBarButton = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.leftBarButtonItem = menuBarButton

        // create search button
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchButtonTapped")
        // add the button to navigationBar
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        // Alamofire on ssl
        let manager = Alamofire.Manager.sharedInstance
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .CancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
                    if credential != nil {
                        disposition = .UseCredential
                    }
                }
            }
            return (disposition, credential)
        }
        
        // request for CMS
        self.request()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    // セルの総数を返す(表示するテーブルの行数)
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.size
    }
    
    // 表示するセルを生成して返す
    // UITableViewDataSource を使う場合は 必須
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // UITableViewCellはテーブルの一つ一つのセルを管理するクラス。
        let cell = table.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        let article: Article = self.articles[indexPath.row] as Article

        // タイトルラベル
        let titlelabel = table.viewWithTag(2) as! UILabel
        titlelabel.text = article.title
        titlelabel.numberOfLines = 0
        titlelabel.sizeToFit()

        // URLより画像を非同期取得
        let imageView = table.viewWithTag(1) as! UIImageView
        imageView.sd_setImageWithURL(NSURL(string:"\(article.image)"))
        
        // 発行元ラベル
        let accountLabel = table.viewWithTag(3) as! UILabel
        accountLabel.text = article.publisher
        
        return cell
    }
    
    // Cell が選択された場合
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        // WebViewController へ遷移するために Segue を呼び出す
        let article: Article = self.articles[indexPath.row] as Article
        selectedUrl = NSURL(string:"\(article.url)")
        if selectedUrl != nil {
            performSegueWithIdentifier("toWebViewController",sender: nil)
        }
    }
    
    // Segue 準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toWebViewController") {
            let webVC: WebViewController = (segue.destinationViewController as? WebViewController)!
        webVC.selectedUrl = selectedUrl
        }
    }
    
    // Web API をコールする
    func request() {
        Alamofire.request(Router.GetArticles()).responseJSON { response in
            if let json = response.result.value as? Array<Dictionary<String,AnyObject>> {
                for j in json {
                    let article: Article = Article(
                        title: j["title"] as! String,
                        url: j["url"] as! String,
                        image: j["image"] as! String,
                        publisher: j["publisher"] as! String
                    )
                    self.articles.set(article)
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