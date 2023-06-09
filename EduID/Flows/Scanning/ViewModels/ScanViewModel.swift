import UIKit
import AVFoundation
import TiqrCoreObjC

final class ScanViewModel: NSObject {
    
    // - delegate
    weak var delegate: ScanViewModelDelegate?
    
    // - av componenets
    let session = AVCaptureSession()
    let output = AVCaptureMetadataOutput()
    
    // - challenge object and type
    var challenge: NSObject?
    var challengeType: TIQRChallengeType?
    
    let frameSize: CGFloat = 275
    
    //MARK: - setup the av camera session
    func setupCaptureSession() {
        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            if let device = device {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                                
                output.metadataObjectTypes = [.qr]
                output.setMetadataObjectsDelegate(self, queue: .main)
                
                // - set rect of interest
                let screenBounds = UIScreen.main.bounds
                let interestOrigin = CGPoint(x: (screenBounds.width - frameSize) / 2 / screenBounds.width, y: (screenBounds.height - frameSize) / 2 / screenBounds.height)
                let interestSize = CGSize(width: frameSize / screenBounds.width, height: frameSize / screenBounds.height)
                
                // I believe in spite of good looking values, this doens't work
//                output.rectOfInterest = CGRect(origin: interestOrigin, size: interestSize)
                
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.session.startRunning()
                }
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - process the meta data
    func processMetaDataObject(object: AVMetadataMachineReadableCodeObject) {
        
        // call the viewcontroller to add green markers
        delegate?.scanViewModelAddPoints(_for: object, viewModel: self)
        
        // after 1s send the meta data to the challenge service
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            ServiceContainer.sharedInstance().challengeService.startChallenge(fromScanResult: object.stringValue ?? "") { [weak self] type, challengeObject, error in
                guard let self = self else { return }
                
                switch type {
                case .enrollment, .authentication:
                    self.challengeType = type
                    self.challenge = challengeObject
                    self.handleScanResult()
                case .invalid:
                    self.delegate?.scanViewModelShowErrorAlert(error: error, viewModel: self)
                default:
                    break
                }
            }
        })
    }
    
    func handleScanResult() {
        delegate?.scanViewModelShowScanAttempt(viewModel: self)
    }
    
    func handleAuthenticationScanResult() {
        guard let challenge = challenge as? AuthenticationChallenge else {
            return
        }
        ServiceContainer.sharedInstance().secretService.secret(for: challenge.identity, touchIDPrompt: "Using Biometry") { data in
            guard let data = data else {
                return
            }
            ServiceContainer.sharedInstance().challengeService.complete(challenge, withSecret: data) { [weak self] success, response, error in
                guard let self = self else { return }
                self.delegate?.scanViewModelAuthenticateSuccess(viewModel: self)
            }
        } failureHandler: { success in
            print(success)
        }
    }
    
    deinit {
        self.session.stopRunning()
        self.session.removeOutput(self.output)
    }
}

//MARK: - preview layer delegate
extension ScanViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0, let firstObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            self.session.stopRunning()
            self.processMetaDataObject(object: firstObject)
        }
    }
}
