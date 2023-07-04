import UIKit
import TinyConstraints

class CreateEduIDFirstTimeDialogViewController: CreateEduIDBaseViewController {

    // - primary button
    let connectButton = EduIDButton(type: .primary, buttonTitle: L.CreateEduID.FirstTimeDialog.ConnectButtonTitle.localization)
    
    // - stack
    var stack: AnimatedVStackView!
    
    // - scroll view
    var scrollView = UIScrollView()
    
    var viewModel: CreateEduIDFirstTimeDialogViewViewModel
    
    //MARK: - init
    init(viewModel: CreateEduIDFirstTimeDialogViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.addInstitutionsCompletion = { urlAuthorization in
            guard let url = URL(string: urlAuthorization.url ?? "") else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        viewModel.alertErrorHandlerDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showNextScreen), name: .didAddLinkedAccounts, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        screenType = .firstTimeDialogScreen
        
        setupUI()
        connectButton.addTarget(self, action: #selector(launchAddInstitutions), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack.animate(onlyThese: [4, 5])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = stack.frame.inset(by: UIEdgeInsets(top: -24, left: -24, bottom: -24, right: -24)).size
    }
    
    //MARK: - setup UI
    func setupUI() {
        // - scroll view setup
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - postertext
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: L.CreateEduID.FirstTimeDialog.MainTextTitle.localization, size: 24, primary: L.CreateEduID.FirstTimeDialog.MainTextTitleBoldPart.localization)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // - textView
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 24 - 16
        
        let attributedText = NSMutableAttributedString(string: L.CreateEduID.FirstTimeDialog.MainText.localization
                                                       , attributes: [.foregroundColor: UIColor.charcoalColor, .font: UIFont.sourceSansProRegular(size: 16), .paragraphStyle: paragraph])
        attributedText.setAttributeTo(part: L.CreateEduID.FirstTimeDialog.MainTextFirstBoldPart.localization, attributes: [.font: UIFont.sourceSansProBold(size: 16), .paragraphStyle: paragraph])
        attributedText.setAttributeTo(part: L.CreateEduID.FirstTimeDialog.MainTextSecondBoldPart.localization, attributes: [.font: UIFont.sourceSansProBold(size: 16), .paragraphStyle: paragraph])
        let textView = TextViewBackgroundColor(attributedText: attributedText, backgroundColor: .yellowColor, insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        
        // - spacing
        let spaceView = UIView()
        
        // - additional text view
        let labelParent = UIView()
        let label = UILabel.plainTextLabelPartlyBold(text: L.CreateEduID.FirstTimeDialog.AddInformationText.localization, partBold: L.CreateEduID.FirstTimeDialog.AddInformationBoldPart.localization)
        labelParent.addSubview(label)
        label.edges(to: labelParent)
        
        // - skip button
        let skipButton = EduIDButton(type: .ghost, buttonTitle: L.CreateEduID.FirstTimeDialog.SkipButtonTitle.localization)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        skipButton.isEnabled = true
        
        // - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterParent, textView, spaceView, labelParent, connectButton, skipButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        // - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: -24, right: -24))
        stack.width(to: scrollView, offset: -48)
        textView.width(to: stack)
        posterLabel.width(to: stack)
        connectButton.width(to: stack, offset: -24)
        skipButton.width(to: stack, offset: -24)
        
        stack.hideAndTriggerAll(onlyThese: [4, 5])
        
    }
    
    @objc func skipAction() {
        self.dismiss(animated: true)
    }
    
    @objc func launchAddInstitutions() {
        viewModel.gotoAddInstitutionsInBrowser()
    }
}

extension CreateEduIDFirstTimeDialogViewController: AlertErrorHandlerDelegate {
    func presentAlert(with error: Error) {
        let alertController = UIAlertController(title: error.eduIdResponseError().title,
                                                message: error.eduIdResponseError().message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .cancel)
        alertController.addAction(alertAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
