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
        camera.preview.frame = view.bounds
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)

        DispatchQueue.global(qos: .userInteractive).async {
            camera.session.startRunning()
        }

        // Observe device orientation changes
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(context.coordinator.orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // Update the preview frame when the view updates
        DispatchQueue.main.async {
            camera.preview?.frame = uiView.bounds
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public class Coordinator {
        var parent: CameraPreview

        init(_ parent: CameraPreview) {
            self.parent = parent
        }

        @objc func orientationChanged() {
            guard let connection = parent.camera.preview?.connection, connection.isVideoOrientationSupported else {
                return
            }

            // Hide the camera preview during rotation to make the transition smoother
            parent.camera.preview?.isHidden = true
            
            // Wait for a short time to complete the rotation (optional)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                let orientation = UIDevice.current.orientation
                connection.videoOrientation = orientation.toVideoOrientation()

                // Update the frame after the rotation
                if let superview = parent.camera.preview?.superlayer?.superlayer {
                    parent.camera.preview?.frame = superview.bounds
                }

                // Show the preview again after updating the orientation and frame
                parent.camera.preview?.isHidden = false
            }
        }
    }
}

fileprivate extension UIDeviceOrientation {
    func toVideoOrientation() -> AVCaptureVideoOrientation {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return .portrait
        }
    }
}
