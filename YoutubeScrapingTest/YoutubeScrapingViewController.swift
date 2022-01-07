
//
//  GoogleWebView.swift
//  YoutubeScrapingUIKit
//
//  Created by Yong Jun Cha on 2021/11/19.
//

import UIKit
import WebKit
class YoutubeScrapingViewController: UIViewController, WKNavigationDelegate {
    
    var youtubeScrapingModel: YoutubeScrapingModel = YoutubeScrapingModel()
    
    fileprivate let GOOGLE_LOGIN_ADDRESS = "https://accounts.google.com/ServiceLogin"
    fileprivate let GOOGLE_MYACCOUNT_PAGE = "https://myaccount.google.com/"
    fileprivate let GOOGLE_SEARCH_HISTORY = "https://myactivity.google.com/activitycontrols/webandapp?view=item&product=19"
    fileprivate let YOUTUBE_SEARCH_HISTORY = "https://myactivity.google.com/activitycontrols/youtube"
    fileprivate let GOOGLE_LOGIN_DATA_EXIST = "https://myaccount.google.com/?utm_source=sign_in_no_continue"
    
    var webView: WKWebView!
    var loginDetectedAction : () -> Void = {}
    
    override func loadView() {
        let preference = WKPreferences()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preference
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: GOOGLE_LOGIN_ADDRESS )
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    // 권한 요청
    func webView(_ webView: WKWebView,
          decidePolicyFor navigationAction: WKNavigationAction,
              preferences: WKWebpagePreferences,
                          decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void){
        print( "권한요청" )
        // If login result is success, hide webview when system request auth to access new page.
        if let url = webView.url {
            if url.absoluteString.contains( GOOGLE_MYACCOUNT_PAGE) {
                webView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 0, height: 0))
                webView.isHidden = true
            }
        }
        return decisionHandler(.allow, preferences)
    }
    
    // 수신시작
    func webView(_ : WKWebView, didCommit: WKNavigation!){
        print("수신 시작")
    }
    
    // 탐색이 완료 되었음
    func webView(_ webView: WKWebView,
                 didFinish: WKNavigation!) {
        print("탐색이 완료")
        print("WebView URL : \(String(describing: webView.url))")
        
        if let url = webView.url {
            
            // Move to search history page if url match with login finish page
            if url.absoluteString.contains( GOOGLE_MYACCOUNT_PAGE) {
                // Youtube
                    let myURL = URL(string: YOUTUBE_SEARCH_HISTORY )
                    let myRequest = URLRequest(url: myURL!)
                    webView.load(myRequest)
            }
            
            
            //Scarping Youtube history data if url match with search Youtube history page
            if url.absoluteString.contains( YOUTUBE_SEARCH_HISTORY ) {
                
                let scrollPoint = CGPoint(x: 0, y: webView.scrollView.contentSize.height * 300)
                webView.scrollView.setContentOffset(scrollPoint, animated: false)//Set false if you doesn't want animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    // @Escaping 예정
                    self.youtubeScrapingModel.insertYoutubeKeywordData(url: url)
                    self.dismiss(animated: false, completion: nil)
                }
            }
            
            // Login Page
            if url.absoluteString.contains( GOOGLE_LOGIN_ADDRESS ) {
                print("LOGIN DETECTED")
                loginDetectedAction()
            }
            
            // When User have ID
            if url.absoluteString.contains( GOOGLE_LOGIN_DATA_EXIST ) {
                print("Google Login Data Exist")
            }
        }
    }
    
    // 초기 탐색 프로세스 중에 오류가 발생했음 - Error Handler
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation: WKNavigation!,
                 withError: Error) {
        print("초기 탐색 프로세스 중에 오류가 발생했음")
    }
    
    // 탐색 중에 오류가 발생했음 - Error Handler
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print("탐색 중에 오류가 발생했음")
    }
    
}
