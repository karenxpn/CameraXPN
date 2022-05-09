//
//  CameraPreview.swift
//  CustomCameraApp
//
//  Created by Karen Mirakyan on 09.05.22.
//

import Foundation
import SwiftUI
import AVFoundation

public struct CameraPreview: UIViewRepresentable {
    @EnvironmentObject var camera: CameraViewModel
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        
        camera.session.startRunning()
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
