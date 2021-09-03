## Release notes
### vNext
* 
### v1.2.0
* Added communication event
* Changed path to `native.html`
### v1.1.2
* Updated the documentation
### v1.1.1
* Update documentation
### v1.1.0
* Add optional onboarding token parameter to init method
### v1.0.0
* First release

# Setup

Minimal supported ios version is 9.0.
```
spec.platform     = :ios, "9.0"
```

The easiest way to integrate widget to iOS application is to use CocoaPods. In your Podfile add the following config:

```
pod 'CereSDK', :git => 'https://github.com/cere-io/sdk-ios.git', :tag => '1.2.0'
```
then run the following command to install new pod:

```
pod install
```

# Initialization

Import cereSDK inside your View, get the SDK instance and call init passing appId, integrationPartnerUserId and your View

```
import CereSDK
...
var sdk: CereSDK = CereSDK.instance
...
sdk.initSDK(appId: "appID", integrationPartnerUserId: "userID", controller: self)
```

# API

Link to generated docs - [https://cere-io.github.io/sdk-ios/](https://cere-io.github.io/sdk-ios/)
