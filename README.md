<p align="center">
    <img src="https://manage.eyedid.ai/img/seeso_logo.467ee6a5.png" height="170">
</p>

<div align="center">
    <h1>Eyedid SDK iOS Sample</h1>
    <a href="https://github.com/visualcamp/eyedid-iOS-sample/releases" alt="release">
        <img src="https://img.shields.io/badge/version-1.0.0--beta-blue" />
    </a>
</div>

## Documentation

- **Overview**: [Eyedid SDK Overview](https://docs.eyedid.ai/docs/document/eyedid-sdk-overview)
- **Quick Start**: [iOS Quick Start Guide](https://docs.eyedid.ai/docs/quick-start/ios-quick-start)
- **API Reference**: [Eyedid SDK iOS API Documentation](https://docs.eyedid.ai/docs/api/ios-api-docs)

## Requirements

- **Minimum iOS Target**: 13.0
- **Device**: Must be run on a real iOS device (emulator not supported)
- **Internet Connection**: Required
- **License Key**: A license key issued from [Eyedid SDK Manage](https://manage.eyedid.ai/) is required

## How to Run

1. **Clone or Download the Project**
  ```bash
    git clone https://github.com/visualcamp/eyedid-ios-sample.git
  ```
2. **Install Dependencies**
   - Navigate to the project directory and run the following command to install all dependencies via CocoaPods:

   ```bash
   cd eyedid-ios-sample
   pod install
   ```
3. **Setting License Key**
  - Obtain a license key from https://manage.eyedid.ai/
  - Open the  [`ViewController.swift`](/EyedidSample/ViewController) file and enter your license key:
    ```swift
    // TODO: change licence key
    let license : String = "typo your license key"
    ```
4. **Grant Camera Permission**
  - Allow the app to access the device’s camera.
5. **Start Tracking**
  - Run the app and start tracking!

## Contact Us
If you have any questions or need assistance, please feel free to [contact us](mailto:development@eyedid.ai) 

----------

## License Information

### SDK License
All rights to the Eyedid iOS SDK are owned by VisualCamp. Unauthorized copying, modification, distribution, or any other form of use is strictly prohibited without explicit permission from VisualCamp. Please refer to the license agreement provided with the SDK for more details.

### Sample Project License
The sample project provided with the Eyedid iOS SDK is distributed under the MIT License. You are free to use, modify, and distribute this sample project, provided that you include the original copyright and permission notice in all copies or substantial portions of the software.
