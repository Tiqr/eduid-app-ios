//
//  CreateEduIDLandingPageViewController.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//

import UIKit
import TinyConstraints

class CreateEduIDLandingPageViewController: EduIDBaseViewController {

    var stack: AnimatedStackView!
    
    //MARK: -lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextScreen)))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stack.animate()
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        //MARK: - create Label
        let posterLabel = UILabel.posterTextLabel(text: "Don't have an eduID yet?", size: 24)
        
        //MARK: - create the textView
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .sourceSansProLight(size: 16)
        textView.textColor = .secondaryColor
        textView.text =
"""
eduID is a central account for users\nassociated with Dutch education and\nresearch. It is yours and exists independent\nof an educational institution.\n\n\t• Use it to login to several services\n\tconnected to SURFconext.
\t• Users without an institution account\n\tcan also request an eduID.
\t• eduID is a lifelong account. It stays valid\n\tafter you graduate.
"""
        //MARK: - create button
        let button = EduIDButton(type: .primary, buttonTitle: "Create a new eduID")
        
        //MARK: - create the stackview
        stack = AnimatedStackView(arrangedSubviews: [posterLabel, textView, button])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.height(34)
        
        horizontalEdgesToView(aView: button, offset: 48)
        
        textView.height(268)
        horizontalEdgesToView(aView: textView, offset: 32)
        
        stack.hideAndTriggerAll()
        
    }
    
    @objc
    private func nextScreen() {
        navigationController?.pushViewController(EnterPersonalInfoViewController(), animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
}
