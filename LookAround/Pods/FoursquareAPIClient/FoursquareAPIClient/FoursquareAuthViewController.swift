//
//  FoursquareAuthViewController.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/25.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import WebKit

@objc protocol FoursquareAuthViewControllerDelegate {
    func foursquareAuthViewControllerDidSucceed(accessToken: String)
    @objc optional func foursquareAuthViewControllerDidFail(error: Error)
}

class FoursquareAuthViewController: UIViewController {
    private let kFoursquareAuthUrlFormat = "https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@"

    var webview: WKWebView!
    var clientId: String
    var callback: String
    var delegate: FoursquareAuthViewControllerDelegate?

    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(clientId: String, callback: String) {
        self.clientId = clientId
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
                                           target: self,
                                           action: #selector(FoursquareAuthViewController.cancelButtonDidTap(_:)))
        navigationItem.leftBarButtonItem = cancelButton

        // WKWebView
        let rect: CGRect = UIScreen.main.bounds
        webview = WKWebView(frame: CGRect(x: 0, y: 64, width: rect.size.width, height: rect.size.height - 64))
        webview.navigationDelegate = self
        view.addSubview(webview!)

        // Encode URL
        let authURLString = String(format: kFoursquareAuthUrlFormat, clientId, callback)
        guard let encodedURLString = authURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("Invalid URL: ", authURLString)
            return
        }

        // Load auth url
        guard let authURL = URL(string: encodedURLString) else {
            print("Invalid URL: ", authURLString)
            return
        }
        _ = webview?.load(URLRequest(url: authURL))
    }

    override func viewDidDisappear(_: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    // MARK: - Private methods

    @objc func cancelButtonDidTap(_: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - WKWebView delegate

extension FoursquareAuthViewController: WKNavigationDelegate {
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString,
            urlString.range(of: "access_token=") != nil {
            // Auth Success
            if let accessToken = urlString.components(separatedBy: "=").last {
                delegate?.foursquareAuthViewControllerDidSucceed(accessToken: accessToken)
                dismiss(animated: true, completion: nil)
                decisionHandler(WKNavigationActionPolicy.cancel)
                return
            }
        }

        decisionHandler(WKNavigationActionPolicy.allow)
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        // Auth failed
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        delegate?.foursquareAuthViewControllerDidFail?(error: error)
    }
}
