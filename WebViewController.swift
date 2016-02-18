//
//  WebViewController.swift
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var selectedUrl: NSURL!
    
    func loadURL() {
        let request = NSURLRequest(URL: selectedUrl)
        webView.loadRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        /* Pageがすべて読み込み終わった時呼ばれるデリゲートメソッド */
    }
    func webViewDidStartLoad(webView: UIWebView) {
        /* Pageがloadされ始めた時、呼ばれるデリゲートメソッド. */
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}