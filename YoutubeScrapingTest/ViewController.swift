//
//  ViewController.swift
//  YoutubeScrapingTest
//
//  Created by Yong Jun Cha on 2021/11/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    var ttt: YoutubeScrapingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func testButtonEvent(_ sender: Any) {
        presentYoutubeWebViewWhenUserNeedToLogin()
    }
    
    private func presentYoutubeWebViewWhenUserNeedToLogin() {
        present(YoutubeScrapingViewController(), animated: true, completion: {print("YOUTUBE WEBVIEW LOGIN PAGE PRESENT")})
    }
}

