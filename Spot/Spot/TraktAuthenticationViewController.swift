//
//  TraktAuthenticationViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 8/30/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class TraktAuthenticationViewController: UIViewController

{
    // MARK: Properties
    var urlRequest: URLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    
    // MARK: Outlets
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //webView.delegate = self
        
        navigationItem.title = "Trakt Authentication"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
            print(urlRequest)
            print(webView.request)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    func cancelAuth() {
        print(webView.request?.url)
        dismiss(animated: true, completion: nil)
    }
}
