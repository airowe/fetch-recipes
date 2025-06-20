//
//  VideoPlayerView.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/18/25.
//

import SwiftUI
import AVKit
import WebKit

struct VideoPlayerView: View {
    let url: URL
    
    var body: some View {
        if url.host?.contains("youtube.com") == true || url.host?.contains("youtu.be") == true {
            // Use WKWebView for YouTube videos
            YouTubeWebView(url: url)
        } else {
            VideoPlayer(player: AVPlayer(url: url))
        }
    }
}

struct YouTubeWebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
