import UIKit
import TinyConstraints

class ActivityViewController: BaseViewController {
    
    let viewModel: ActivityViewModel
    
    weak var delegate: ActivityViewControllerDelegate?

    //MARK: - init
    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .activityLandingScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if delegate?.shouldUpdate() == true {
            self.setupUI(model: nil)
            delegate?.didUpdate()
            viewModel.getData()
        }
        viewModel.dataAvailableClosure = { [weak self] model in
            self?.setupUI(model: model)
        }
    }
    
    //MARK: - setup UI
    func setupUI(model: PersonalInfoDataCallbackModel?) {
        view.subviews.forEach { $0.removeFromSuperview() }

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: L.DataActivity.Title.localization, primary: L.DataActivity.Title.localization)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        let description = UILabel.plainTextLabelPartlyBold(text: L.DataActivity.Info.localization, partBold: "")
        
        let appsHeader = UILabel.plainTextLabelPartlyBold(text: L.DataActivity.AppsHeader.localization, partBold:  L.DataActivity.AppsHeader.localization)
        
        let stack = AnimatedVStackView(arrangedSubviews: [posterParent, description, appsHeader])
        
        if let model = model {
            var addedKeysCount = 0
            if let keys = model.userResponse.eduIdPerServiceProvider?.keys {
                for key in keys {
                    if let eduID = model.userResponse.eduIdPerServiceProvider?[key] {
                        let control = ActivityControlCollapsible(
                            logoImageURL: eduID.serviceLogoUrl ?? "",
                            institutionTitle: eduID.serviceName ?? "",
                            date: Date(timeIntervalSince1970: Double((eduID.createdAt ?? 0) / 1000)),
                            uniqueId: eduID.serviceProviderEntityId ?? "",
                            removeAction: { [weak self] in
                                self?.delegate?.goToDeleteService(service: eduID)
                            }
                        )
                        addedKeysCount += 1
                        stack.addArrangedSubview(control)
                        control.widthToSuperview(offset: -48)
                    }
                }
            }
            if addedKeysCount == 0 {
                let noServicesLabel = UILabel.plainTextLabelPartlyBold(
                    text: L.DataActivity.NoServices.localization,
                    partBold: ""
                )
                stack.addArrangedSubview(noServicesLabel)
                noServicesLabel.textAlignment = .center
                noServicesLabel.height(160)
                noServicesLabel.widthToSuperview(offset: -48)
            }
        } else {
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.height(80)
            stack.addArrangedSubview(loadingIndicator)
            loadingIndicator.widthToSuperview()
            loadingIndicator.startAnimating()
        }
        stack.spacing = 16
        stack.setCustomSpacing(24, after: description)
        stack.alignment = .center
        
        // - constraints
        scrollView.addSubview(stack)
        stack.edges(to: scrollView, insets: .vertical(24))
        stack.width(to: scrollView)
        posterParent.widthToSuperview(offset: -48)
        description.widthToSuperview(offset: -48)
        appsHeader.widthToSuperview(offset: -48)
    }
    
    @objc
    func dismissActivityScreen() {
        delegate?.activityViewControllerDismissActivityFlow(viewController: self)
    }
    
    override func goBack() {
        delegate?.activityViewControllerDismissActivityFlow(viewController: self)
    }
}
