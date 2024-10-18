//
//  ViewController.swift
//  EyedidSample
//
//  Created by David on 10/18/24.
//

import UIKit
import AVFoundation
import Eyedid

class ViewController: UIViewController {

  @IBOutlet weak var startBtn: UIButton!
  @IBOutlet weak var stopBtn: UIButton!
  @IBOutlet weak var caliBtn: UIButton!

  @IBOutlet weak var versionLabel: UILabel!
  
  var tracker: GazeTracker?
  // TODO: change licence key
  let license : String = "typo your license key"

  let pointView : PointView = PointView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
  let calibrationPointView : CalibrationPointView = CalibrationPointView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

  var index = 0
  let colorList : [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.cyan]

  let semaphore = DispatchSemaphore(value: 1)
  var isMove : Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    versionLabel.text = "Version : \(GazeTracker.getFrameworkVersion())"
    checkCameraAuthorizationStatus()

    startBtn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    stopBtn.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    caliBtn.addTarget(self, action: #selector(caliButtonTapped), for: .touchUpInside)

    startBtn.isEnabled = false
    stopBtn.isEnabled = false
    caliBtn.isEnabled = false

    self.view.addSubview(pointView)
    self.view.addSubview(calibrationPointView)
    pointView.isHidden = true
    self.calibrationPointView.isHidden = true

  }

  // Function to check and request camera authorization
  func checkCameraAuthorizationStatus() {
    let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

    switch cameraAuthorizationStatus {
      case .authorized:
        // Camera access is already authorized
        print("Camera access is authorized.")
        self.initGazeTracker()
      case .notDetermined:
        // Authorization has not been requested yet, request permission
        AVCaptureDevice.requestAccess(for: .video) { granted in
          if granted {
            self.initGazeTracker()
            print("Camera access granted.")
          } else {
            print("Camera access denied.")
          }
        }
      case .denied, .restricted:
        // Access is denied or restricted
        print("Camera access is denied or restricted.")
        // Prompt user to go to settings
        showSettingsAlert()
      @unknown default:
        fatalError("Unknown authorization status.")
    }
  }

  // Function to show an alert prompting the user to go to settings
  func showSettingsAlert() {
      let alert = UIAlertController(title: "Camera Access Needed", message: "Please allow camera access in settings to use the camera.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
          if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
          }
      }))
      present(alert, animated: true, completion: nil)
  }

  func initGazeTracker() {
    GazeTracker.initGazeTracker(license: license, delegate: self)
  }

  // Button action functions
  @objc func startButtonTapped() {
      print("Start button tapped.")
      // Add functionality for start button
    self.tracker?.startTracking()
  }

  @objc func stopButtonTapped() {
      print("Stop button tapped.")
      // Add functionality for stop button
    self.tracker?.stopTracking()
  }

  @objc func caliButtonTapped() {
      print("Calibration button tapped.")
      // Add functionality for calibration button
    self.tracker?.startCalibration(mode: .fivePoint, criteria: .default, region: UIScreen.main.bounds)
    self.pointView.isHidden = true
    self.startBtn.isHidden = true
    self.stopBtn.isHidden = true
    self.caliBtn.isHidden = true
    self.versionLabel.isHidden = true
  }


  func showErrorAlert(message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }

}

extension ViewController: InitializationDelegate ,TrackingDelegate, CalibrationDelegate, StatusDelegate {

  func onInitialized(tracker: GazeTracker?, error: InitializationError) {
    if error == .errorNone {
      self.tracker = tracker
      self.tracker?.trackingDelegate = self
      self.tracker?.calibrationDelegate = self
      self.tracker?.statusDelegate = self
      self.startBtn.isEnabled = true
    } else {
      showErrorAlert(message: error.description)
    }
  }

  func onMetrics(timestamp: Int, gazeInfo: GazeInfo, faceInfo: FaceInfo, blinkInfo: BlinkInfo, userStatusInfo: UserStatusInfo) {
    DispatchQueue.main.async {
      if gazeInfo.trackingState == .success && self.tracker?.isCalibrating() == false {
        self.pointView.center = CGPoint(x: CGFloat(gazeInfo.x), y: CGFloat(gazeInfo.y))
      }
    }
  }

  func onCalibrationNextPoint(x: Double, y: Double) {
    self.calibrationPointView.reset(to:self.colorList[self.index])
    self.calibrationPointView.movePoistion(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
    self.calibrationPointView.setProgress(progress: 0)
    self.index += 1

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.calibrationPointView.isHidden = false
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
      self.tracker?.startCollectSamples()
    }
  }

  func onCalibrationProgress(progress: Double) {
    self.calibrationPointView.setProgress(progress: progress)
  }

  func onCalibrationFinished(calibrationData: [Double]) {
    self.calibrationPointView.isHidden = true
    self.pointView.isHidden = false

    self.startBtn.isHidden = false
    self.stopBtn.isHidden = false
    self.caliBtn.isHidden = false
    self.versionLabel.isHidden = false
    self.index = 0
  }

  func onStarted() {
    self.stopBtn.isEnabled = true
    self.startBtn.isEnabled = false
    self.caliBtn.isEnabled = true
    self.pointView.isHidden = false
  }

  func onStopped(error: StatusError) {
    self.startBtn.isEnabled = true
    self.stopBtn.isEnabled = false
    self.caliBtn.isEnabled = false
  }
}
