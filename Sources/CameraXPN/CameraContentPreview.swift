//
//  CameraContentPreview.swift
//  CustomCameraApp
//
//  Created by Karen Mirakyan on 09.05.22.
//

import SwiftUI
import AVKit
import UIKit

public struct CameraContentPreview: View {
    let url: URL?
    
    public var body: some View {
        
        GeometryReader { proxy in

            ZStack {
                if url != nil {
                    if checkURL() == "video" {
                        let player = AVPlayer(url: url!)
                        AVPlayerControllerRepresented(player: player)
                            .onAppear {
                                player.play()
                            }.onDisappear {
                                player.pause()
                            }
                    } else {
                            Image(uiImage: UIImage(contentsOfFile: url!.path)!)
                                .resizable()
                                .scaledToFill()
                    }
                }
            }.frame(width: proxy.size.width, height: proxy.size.height)
            .background(Color.black)
        }

    }
    
    func checkURL() -> String {
        if url!.absoluteString.hasSuffix(".mov") {
            return "video"
        }
        return "photo"
    }
}


struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = AVLayerVideoGravity.resizeAspectFill

        controller.edgesForExtendedLayout = []

        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

