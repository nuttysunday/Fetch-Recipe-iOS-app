//
//  ArticleView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//


import SwiftUI
import WebKit

struct ArticleView: View {
    var sourceUrl: URL
    
    var body: some View {
        WebView(url: sourceUrl)
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
