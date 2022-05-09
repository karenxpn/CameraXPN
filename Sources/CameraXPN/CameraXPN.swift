//
//  CameraXPN.swift
//  CustomCameraApp
//
//  Created by Karen Mirakyan on 09.05.22.
//


import SwiftUI

/**
 Photo and video recording view.
 
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
 
 
- Parameters: 
    - action: action that returns url of our content with extension video.mov or photo.jpg
    - font: font you need to present user media button
    - permissionAlertMessage: a message that will be shown if video or audio access is denied
    - retakeButtonBackground: retake button image color
    - retakeButtonForeground: retakeButtonForeground description
    - backButtonBackground: backButton  button image color
    - backButtonForeground: backButtonForeground description
    - closeButtonBackground: closeButton  button image color
    - closeButtonForeground: closeButtonForeground description
    - takeImageButtonColor: takeImage  button  color
    - recordVideoButtonColor: recordVideo  button  color
    - flipCameraBackground: flipCameraBackground description
    - flipCameraForeground: flipCamera button image color
    - useMediaContent: useMediaContent description
    - useMediaButtonForeground: useMediButton text color
    - useMediaButtonBackground: useMediaButtonBackground color
 
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
                videoAllowed: Bool = true) {
        
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
    }
    
    public var body: some View {
        ZStack {
            
            CameraPreview()
                .environmentObject(camera)
                .ignoresSafeArea(.all, edges: .all)
            
            
            if camera.isTaken {
                CameraContentPreview(url: camera.previewURL)
                    .ignoresSafeArea(.all, edges: .all)
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
                        }.padding(.leading)
                        
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
                        }.padding(.leading)
                        
                        
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
                        }.padding(.trailing)
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
                        }.padding(.trailing)
                        
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
                                    .frame(width: 75, height: 75)
                                
                                Circle()
                                    .stroke( camera.video ? recordVideoButtonColor : takeImageButtonColor, lineWidth: 2)
                                    .frame(width: 85, height: 85)
                            }
                            
                        }.simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5).onEnded({ value in
                                if camera.recordPermission == .granted && videoAllowed{
                                    camera.video = true
                                    camera.setUp()
                                    camera.startRecordinng()
                                }
                            })
                        )
                    }
                }.frame(height: 75)
                    .padding(.bottom)
                
            }
            
        }.onAppear {
            camera.checkPermission()
            camera.checkAudioPermission()
        }.alert(isPresented: $camera.alert) {
            Alert(title: Text(NSLocalizedString("youFoundInterlocutor", comment: "")),
                  primaryButton: .default(Text(NSLocalizedString("goToSettings", comment: "")), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                  secondaryButton: .cancel(Text(NSLocalizedString("cancel", comment: ""))))
        }.onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if camera.recordedDuration <= 15 && camera.isRecording {
                camera.recordedDuration += 1
            }
            
            if camera.recordedDuration >= 15 && camera.isRecording {
                camera.stopRecording()
            }
        }
    }
}
