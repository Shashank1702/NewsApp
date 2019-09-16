
import UIKit
import SVProgressHUD
import WebKit

class DetailViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate {
    
    //mark: variable's
    var url = ""
    var webview: WKWebView?

    @IBOutlet weak var viewForWebView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webview = WKWebView(frame: view.bounds)
        webview?.scrollView.showsVerticalScrollIndicator = false
        webview?.scrollView.showsHorizontalScrollIndicator = false
        
        webview?.frame = (self.viewForWebView?.bounds)!
        viewForWebView.addSubview(webview!)
        SVProgressHUD.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        webview?.frame = (self.viewForWebView?.bounds)!
        webview?.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: self.url)!
        webview?.load(URLRequest(url: url))
       
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

