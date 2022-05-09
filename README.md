# CameraXPN

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

- Parameters: Only font is required parameter
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
