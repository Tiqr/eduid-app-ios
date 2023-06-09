import UIKit
import TinyConstraints
import TiqrCoreObjC
import AVFoundation

class ScanViewController: UIViewController, ScreenWithScreenType {
    
    // - delegate
    weak var delegate: ScanViewControllerDelegate?
    
    // - screen type
    var screenType: ScreenType = .scanScreen
    
    var overlayView = ScanOverlayView(frame: .zero)
    
    private var scanMode: ScanType = .none
    
    init(viewModel: ScanViewModel, for mode: ScanType) {
        self.viewModel = viewModel
        self.scanMode = mode
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - viewmodel
    let viewModel: ScanViewModel
    
    // - flash button
    private let flashButton = UIButton()
    private var flashIsON: Bool = false
    
    // - audio visual components
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    // - middel qr frame view
    private let middelSpaceView = UIImageView(image: .qrFrame)
    
    // - gradient layer
    private var gradientLayer: CAGradientLayer?

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(overlayView)
        addGradient()
        setupScanningFrameUI()
        previewLayer.session = viewModel.session
        viewModel.setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissScanScreen))
        overlayView.points = nil
        overlayView.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.session.stopRunning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        previewLayer.frame = view.bounds
        overlayView.frame = view.bounds
        gradientLayer?.frame = view.bounds
    }
    
    //MARK: - add gradient layer
    private func addGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor] as [Any]?
        gradientLayer?.locations = [NSNumber(value: 0.1), NSNumber(value: 0.2), NSNumber(value: 0.8), NSNumber(value: 0.9)]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(gradientLayer!)
    }
    
    private func setupScanningFrameUI() {
        // - create the dark frame with image
        let upperDarkView = UIView()
        upperDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        flashButton.setImage(.flashLightOff, for: .normal)
        flashButton.setImage(.flashLight, for: .selected)
        flashButton.size(CGSize(width: 50, height: 50))
        flashButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        upperDarkView.addSubview(flashButton)
        flashButton.trailing(to: upperDarkView, offset: -36)
        flashButton.top(to: upperDarkView, offset: 100)
        let middelLeftDarkView = UIView()
        middelLeftDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        
        // - the imageview containing the frame lines
        let middelRightDarkView = UIView()
        middelRightDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        let middelStack = UIStackView(arrangedSubviews: [middelLeftDarkView, middelSpaceView, middelRightDarkView])
        let lowerDarkView = UIView()
        lowerDarkView.backgroundColor = .black.withAlphaComponent(0.5)
        
        // - explanationText
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = .center
        let attributedText = NSMutableAttributedString(string: """
Don’t see a QR code?
Go to eduid.nl/security
Create your personal QR code
Scan it here
""", attributes: [.foregroundColor: UIColor.white, .font: UIFont.sourceSansProRegular(size: 18), .paragraphStyle: paragraph])
        
        attributedText.setAttributeTo(part: "Don’t see a QR code?", attributes: [.font: UIFont.sourceSansProBold(size: 24)])
        attributedText.setAttributeTo(part: "eduid.nl/security", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.white])
        label.attributedText = attributedText
        label.sizeToFit()
        lowerDarkView.addSubview(label)
        label.center(in: lowerDarkView)
        
        // - the stack view holding the entire frame
        let vStack = UIStackView(arrangedSubviews: [upperDarkView, middelStack, lowerDarkView])
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.distribution = .fill
        view.addSubview(vStack)
        
        // - constraints
        vStack.edgesToSuperview()
        middelSpaceView.size(CGSize(width: 275, height: 275))
        middelRightDarkView.height(to: middelSpaceView)
        middelLeftDarkView.height(to: middelSpaceView)
        upperDarkView.size(to: lowerDarkView)
        middelLeftDarkView.size(to: middelRightDarkView)
    }
    
    //MARK: - toggle flash action
    @objc
    private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else { print("Torch isn't available"); return }

        do {
            try device.lockForConfiguration()
            device.torchMode = !flashIsON ? .on : .off
            device.unlockForConfiguration()
            flashIsON.toggle()
            flashButton.isSelected.toggle()
        } catch {
            print("Torch can't be used")
        }
    }
    
    @objc
    func dismissScanScreen() {
        delegate?.scanViewControllerDismissScanFlow(viewController: self)
    }
}

//MARK: - handle delegate methods from viemodel
extension ScanViewController: ScanViewModelDelegate {
    
    func scanViewModelShowErrorAlert(error: Any, viewModel: ScanViewModel) {
        
        // present a dialog sheet with reason text
        let sheet = UIAlertController(title: "Error", message: (error as? Error)?.localizedDescription, preferredStyle: .actionSheet)
        
        // action to continue scanning - start session
        sheet.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] action in
            sheet.dismiss(animated: true)
            
            // remove marker points
            self?.overlayView.points = []
            
            // restart the av session
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.viewModel.session.startRunning()
            }
        })
        present(sheet, animated: true)
    }
    
    func scanViewModelShowScanAttempt(viewModel: ScanViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self = self else { return }
            switch self.scanMode {
            case .enrol:
                self.delegate?.verifyScanResultForEnroll(viewController: self, viewModel: viewModel)
            case .login: self.delegate?.scanViewControllerPromptUserWithVerifyScreen(viewController: self, viewModel: viewModel)
            default: break
            }
        })
    }
    
    func scanViewModelAddPoints(_for object: AVMetadataMachineReadableCodeObject, viewModel: ScanViewModel) {
        let projectedObject = previewLayer.transformedMetadataObject(for: object) as! AVMetadataMachineReadableCodeObject
        for corner in projectedObject.corners {
            overlayView.addPoint(corner)
        }
    }
    
    func scanViewModelAuthenticateSuccess(viewModel: ScanViewModel) {
        delegate?.scanViewControllerShowConfirmScreen(viewController: self)
    }
}

enum ScanType {
    case enrol, login, none
}
