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
                        .aspectRatio(contentMode: .fill)
                }
            }
        }.background(Color.black)
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
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

