# Setup

Minimal supported ios version is 9.0.
```
spec.platform     = :ios, "9.0"
```

The easiest way to integrate widget to iOS application is to use CocoaPods. In your Podfile add the following config:

```
source 'https://github.com/cere-io/sdk-ios.git'
pod 'CereSDK', '~> 1.0.0'
```
then run the following command to install new pod:

```
pod install
```

# Initialisation

Import cereSDK inside your View, get the SDK instance and call init passing appId, integrationPartnerUserId and your View

```
import CereSDK
...
var sdk: CereSDK = CereSDK.instance
...
sdk.initSDK(appId: "appID", integrationPartnerUserId: "userID", controller: self)
```

# API

Link to generated docs (TODO)
