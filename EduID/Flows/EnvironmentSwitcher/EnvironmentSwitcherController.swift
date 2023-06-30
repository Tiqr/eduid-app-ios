//
//  EnvironmentSwitcherController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 29..
//

import Foundation
import UIKit

class EnvironmentSwitcherController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    private func setup() {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        let insetView = UIView()
        insetView.backgroundColor = .white
        view.addSubview(insetView)
        insetView.horizontalToSuperview(insets: .horizontal(20))
        insetView.centerYToSuperview()
        let title = UILabel.posterTextLabelBicolor(text: L.EnvironmentSwitcher.Title.localization, primary: "")
        let subtitle = UILabel.plainTextLabelPartlyBold(text: L.EnvironmentSwitcher.Subtitle.localization)
        let stack = UIStackView(arrangedSubviews: [title, subtitle])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        insetView.addSubview(stack)
        stack.edgesToSuperview(insets: .uniform(20))
        EnvironmentService.shared.environments.enumerated().forEach { (index, environment) in
            let isCurrent = EnvironmentService.shared.currentEnvironment.name == environment.name
            let button = EduIDButton(type: .ghost, buttonTitle: environment.name)
            if isCurrent {
                button.setImage(.strokedCheckmark, for: .normal)
                button.imageEdgeInsets = .left(-16)

            }
            stack.addArrangedSubview(button)
            button.widthToSuperview()
            button.tag = index
            button.addTarget(self, action: #selector(environmentButtonClicked), for: .touchUpInside)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    func dismissPopup() {
        self.dismiss(animated: true)
    }
    
    @objc
    func environmentButtonClicked(_ sender: UIButton) {
        let environmentIndex = sender.tag
        let environment = EnvironmentService.shared.environments[environmentIndex]
        EnvironmentService.shared.setEnvironment(environment)
        self.dismiss(animated: true)
    }
}
