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
        
        if let conn = camera.preview?.connection, conn.isVideoOrientationSupported {
            conn.videoOrientation = UIApplication.shared.interfaceOrientation.videoOrientation
        }

        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            camera.session.startRunning()
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) { }
}


fileprivate extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation {
        switch self {
            case .portraitUpsideDown: return .portraitUpsideDown
            case .landscapeRight: return .landscapeRight
            case .landscapeLeft: return .landscapeLeft
            case .portrait: return .portrait
            default: return .portrait
        }
    }
}

fileprivate extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    var interfaceOrientation: UIInterfaceOrientation {
        keyWindow?
            .windowScene?
            .interfaceOrientation ?? .portrait
    }
}
