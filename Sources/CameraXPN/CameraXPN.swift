//
//  CameraXPN.swift
//  CustomCameraApp
//
//  Created by Karen Mirakyan on 09.05.22.
//


import SwiftUI

/**
 SwiftUI Photo and Video recording view.
 
# Permissions
To avoid unexpected crashes be sure enabled camera and audio access in your info.plist
 
# Funcionality
Tap to take image and hold the button to start recording view.
On the top left corner you can see flip camera icon which will toggle front-back cameras
 
# Code
```
CameraXPN(action: { url, data in
    print(url)
    print(data.count)
}, font: .subheadline, permissionMessgae: "Permission Denied")
```
 
 */
public struct CameraXPN: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var camera = CameraViewModel()
    
    let action: ((URL, Data) -> Void)
    let font: Font
    let permissionAlertMessage: String
    
    
    var retakeButtonBackground: Color
    var retakeButtonForeground: Color
    
    var backButtonBackground: Color
    var backButtonForeground: Color
    
    var closeButtonBackground: Color
    var closeButtonForeground: Color
    
    var takeImageButtonColor: Color
    var recordVideoButtonColor: Color
    
    var flipCameraBackground: Color
    var flipCameraForeground: Color
    
    
    var useMediaContent: String
    var useMediaButtonForeground: Color
    var useMediaButtonBackground: Color
    
    var videoAllowed: Bool
    let maxVideoDuration: Int
    
    
    /// Description
    /// - Parameters:
    ///   - action: action that returns url of our content with extension video.mov or photo.jpg
    ///   - font: font you need to present user media button
    ///   - permissionMessgae: a message that will be shown if video or audio access is denied
    ///   - retakeButtonBackground: retakeButton background description
    ///   - retakeButtonForeground: retake button image color
    ///   - backButtonBackground: backButton background color
    ///   - backButtonForeground: backButton  button image color
    ///   - closeButtonBackground: close button background color
    ///   - closeButtonForeground: close button image color
    ///   - takeImageButtonColor: take image button color
    ///   - recordVideoButtonColor: record video button color
    ///   - flipCameraBackground: flip camera button background
    ///   - flipCameraForeground: flip camera button image color
    ///   - useMediaContent: use media text that can be replaced
    ///   - useMediaButtonForeground: use media button text color
    ///   - useMediaButtonBackground: use media button background color
    ///   - videoAllowed: video can be allowed or not
    ///   - maxVideoDuration: set maximum duration of the video you want to record
    ///
    public init(action: @escaping ((URL, Data) -> Void), font: Font,
                permissionMessgae: String,
                retakeButtonBackground: Color = .white,
                retakeButtonForeground: Color = .black,
                
                backButtonBackground: Color = .white,
                backButtonForeground: Color = .black,
                
                closeButtonBackground: Color = .white,
                closeButtonForeground: Color = .black,
                
                takeImageButtonColor: Color = .white,
                recordVideoButtonColor: Color = .red,
                
                flipCameraBackground: Color = .white,
                flipCameraForeground: Color = .black,
                
                
                useMediaContent: String = "Use This Media",
                useMediaButtonForeground: Color = .black,
                useMediaButtonBackground: Color = .white,
                videoAllowed: Bool = true,
                maxVideoDuration: Int = 15) {
        
        self.action = action
        self.font = font
        self.permissionAlertMessage = permissionMessgae
        self.retakeButtonBackground = retakeButtonBackground
        self.retakeButtonForeground = retakeButtonForeground
        
        self.closeButtonBackground = closeButtonBackground
        self.closeButtonForeground = closeButtonForeground
        
        self.backButtonBackground = backButtonBackground
        self.backButtonForeground = backButtonForeground
        
        self.takeImageButtonColor = takeImageButtonColor
        self.recordVideoButtonColor = recordVideoButtonColor
        
        self.flipCameraBackground = flipCameraBackground
        self.flipCameraForeground = flipCameraForeground
        
        self.useMediaContent = useMediaContent
        self.useMediaButtonBackground = useMediaButtonBackground
        self.useMediaButtonForeground = useMediaButtonForeground
        
        self.videoAllowed = videoAllowed
        self.maxVideoDuration = maxVideoDuration
    }
    
    public var body: some View {
        ZStack {
            
            CameraPreview()
                .environmentObject(camera)
                .ignoresSafeArea(.all, edges: .all)
            
            
            if camera.isTaken {
                CameraContentPreview(url: camera.previewURL)
                    .ignoresSafeArea(.all, edges: .vertical)
            }
            
            
            VStack {
                
                if camera.isTaken {
                    HStack {
                        Button {
                            camera.retakePic()
                        } label: {
                            
                            Image(systemName: "chevron.backward")
                                .foregroundColor(backButtonForeground)
                                .padding()
                                .background(backButtonBackground)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                    }.padding(.top)
                }
                
                if !camera.isTaken && !camera.isRecording {
                    HStack {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(closeButtonForeground)
                                .padding()
                                .background(closeButtonBackground)
                                .clipShape(Circle())
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            if camera.position == .back {
                                camera.position = .front
                            } else {
                                camera.position = .back
                            }
                            
                            camera.setUp()
                            
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                .foregroundColor(flipCameraForeground)
                                .padding()
                                .background(flipCameraBackground)
                                .clipShape(Circle())
                        }
                    }.padding(.top)
                }
                
                Spacer()
                
                HStack {
                    
                    if camera.isTaken {
                        
                        Spacer()
                        
                        Button {
                            if let url = camera.previewURL {
                                action(url, camera.mediaData)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Text(useMediaContent)
                                .foregroundColor(.black)
                                .font(font)
                                .kerning(0.12)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        
                    } else {
                        
                        Button {
                            
                            if camera.video {
                                camera.stopRecording()
                                // in the end of taking video -> camera.video need to become false again
                            } else {
                                camera.takePic()
                            }
                            
                        } label: {
                            
                            ZStack {
                                Circle()
                                    .fill( camera.video ? recordVideoButtonColor : takeImageButtonColor)
                                    .frame(width: camera.video ? 95 : 75, height: camera.video ? 95 : 75)
                                
                                Circle()
                                    .stroke( camera.video ? recordVideoButtonColor : takeImageButtonColor, lineWidth: 2)
                                    .frame(width: camera.video ? 105 : 85, height: camera.video ? 105 : 85)
                            }
                            
                        }.simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5).onEnded({ value in
                                if camera.recordPermission == .granted && videoAllowed{
                                    withAnimation {
                                        camera.video = true
                                        camera.setUp()
                                        camera.startRecordinng()
                                    }
                                }
                            })
                        ).buttonStyle(.plain)
                    }
                }.frame(height: 105)
                    .padding(.bottom)
                
            }.padding(.horizontal)
            
        }.onAppear {
            camera.checkPermission()
            if videoAllowed {
                camera.checkAudioPermission()
            }
        }.alert(isPresented: $camera.alert) {
            Alert(title: Text(NSLocalizedString("youFoundInterlocutor", comment: "")),
                  primaryButton: .default(Text(NSLocalizedString("goToSettings", comment: "")), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                  secondaryButton: .cancel(Text(NSLocalizedString("cancel", comment: ""))))
        }.onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if camera.recordedDuration <= Double(maxVideoDuration) && camera.isRecording {
                camera.recordedDuration += 0.01
            }
            
            if camera.recordedDuration >= Double(maxVideoDuration) && camera.isRecording {
                camera.stopRecording()
            }
        }
    }
}
