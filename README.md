# CameraXPN
SwiftUI Photo and Video recording view.


# Permissions
To avoid unexpected crashes be sure to enable the camera and audio access in your info.plist


# Funcionality
Tap to take an image and hold the button to start recording view.
You can see a flip camera icon on the top left corner that will toggle front-back cameras.
All parameters are customizable, so feel free to get your preferred view.

# Preview
<p float="left">
  <img src="https://github.com/karenxpn/CameraXPN/blob/main/images/take_image.jpeg?raw=true" width="32%" />
  <img src="https://github.com/karenxpn/CameraXPN/blob/main/images/video_recording.jpeg?raw=true" width="32%" /> 
  <img src="https://github.com/karenxpn/CameraXPN/blob/main/images/preview.jpeg?raw=true" width="32%" />
</p>

# Installation 
### Swift Package Manager

```swift
https://github.com/karenxpn/CameraXPN
```

# Code
```swift
import SwiftUI
import CameraXPN

struct ContentView: View {
    var body: some View {
        CameraXPN(action: { url, data in
            print(url)
            print(data.count)
        }, font: .subheadline, permissionMessgae: "Permission Denied")
    }
}
```


### Parameters:
- `action`: action that returns url of our content with extension video.mov or photo.jpg and binary data 
- `font`: font you need to present user media button
- `permissionMessgae`: a message that will be shown if video or audio access is denied
- `retakeButtonBackground`: retakeButton background description
- `retakeButtonForeground`: retake button image color
- `backButtonBackground`: backButton background color
- `backButtonForeground`: backButton  button image color
- `closeButtonBackground`: close button background color
- `closeButtonForeground`: close button image color
- `takeImageButtonColor`: take image button color
- `recordVideoButtonColor`: record video button color
- `flipCameraBackground`: flip camera button background
- `flipCameraForeground`: flip camera button image color
- `useMediaContent`: use media text that can be replaced
- `useMediaButtonForeground`: use media button text color
- `useMediaButtonBackground`: use media button background color
- `videoAllowed`: video can be allowed or not
- `maxVideoDuration`: set maximum duration of the video you want to record

