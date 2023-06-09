import UIKit
import TinyConstraints

class ActivityViewController: BaseViewController {
    
    let viewModel: ActivityViewModel
    
    var stack: AnimatedVStackView!
    let scrollView = UIScrollView()
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
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissActivityScreen))
        viewModel.loadData()
        viewModel.dataAvailableClosure = { [weak self] model in
            self?.setupUI(model: model)
        }
    }
    
    //MARK: - setup UI
    func setupUI(model: PersonalInfoDataCallbackModel) {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Data & Activity", primary: "Data & Activity")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
Each service you accessed through eduID receives certain personal data (attributes) from your eduID account. E.g. your name & email address or a pseudonym which the service can use to uniquely identify you.
""", partBold: "")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        
        
        stack = AnimatedVStackView(arrangedSubviews: [posterParent, textParent])
        
        if let keys = model.userResponse.eduIdPerServiceProvider?.keys {
            
            for key in keys {
                let eduID = model.userResponse.eduIdPerServiceProvider?[key]
                let control = ActivityControlCollapsible(logoImageURL: eduID?.serviceLogoUrl ?? "", institutionTitle: eduID?.serviceName ?? "", date: Date(timeIntervalSince1970: Double(eduID?.createdAt ?? 0)), uniqueId: eduID?.serviceProviderEntityId ?? "", removeAction: {})
                stack.addArrangedSubview(control)
            }
            
        }
        stack.alignment = .center
        
        // - constraints
        scrollView.addSubview(stack)
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 0, bottom: -24, right: 0))
        stack.width(to: scrollView)
        posterParent.width(to: stack, offset: -48)
        textParent.width(to: stack, offset: -48)
    }
    
    @objc
    func dismissActivityScreen() {
        delegate?.activityViewControllerDismissActivityFlow(viewController: self)
    }
}
