//
//  DetailViewController.swift
//  ApiPullApp
//
//  Created by Akdag on 20.02.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView : WKWebView!
    var detailPetition : Petition?
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailPetition = detailPetition else{return}
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size : %150 ;}</style>
        </head>
        <body>
         \(detailPetition.body)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    

   

}
