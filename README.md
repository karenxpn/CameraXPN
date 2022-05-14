# CameraXPN

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

# CameraXPN

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

- Parameters:
    - action: action that returns url of our content with extension video.mov or photo.jpg
    - font: font you need to present user media button
    - permissionMessgae: a message that will be shown if video or audio access is denied
    - retakeButtonBackground: retakeButton background description
    - retakeButtonForeground: retake button image color
    - backButtonBackground: backButton background color
    - backButtonForeground: backButton  button image color
    - closeButtonBackground: close button background color
    - closeButtonForeground: close button image color
    - takeImageButtonColor: take image button color
    - recordVideoButtonColor: record video button color
    - flipCameraBackground: flip camera button background
    - flipCameraForeground: flip camera button image color
    - useMediaContent: use media text that can be replaced
    - useMediaButtonForeground: use media button text color
    - useMediaButtonBackground: use media button background color
    - videoAllowed: video can be allowed or not
    - maxVideoDuration: set maximum duration of the video you want to record

