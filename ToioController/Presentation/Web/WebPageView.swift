//
//  WebPageView.swift
//  ToioController
//

import SwiftUI
import WebKit

/// Webページを表示する。ページ側に見出しがあるので、画面のタイトルは出さない
struct WebPageView: View {
    let url: URL
    var onBack: () -> Void = {}

    var body: some View {
        RailScreen(top: .back(label: R.string.localizeString.commonBack(), action: onBack)) {
            WebView(url: url)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Palette.border, lineWidth: 1))
                .padding(.top, 6)
                .padding(.trailing, 4)
        }
    }
}

/// WKWebViewのラッパー。新しいウィンドウで開くリンク(App Storeなど)は外部で開く
private struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKUIDelegate {
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            // The app catalog opens App Store and contact links in a new window.
            if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
                UIApplication.shared.open(url)
            }
            return nil
        }
    }
}
