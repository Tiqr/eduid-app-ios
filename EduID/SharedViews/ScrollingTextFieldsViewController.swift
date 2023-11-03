import UIKit

class ScrollingTextFieldsViewController: BaseViewController {

    private var keyboardHeight: CGFloat?
    private var isKeyBoardOnScreen = false
    static let smallBuffer: CGFloat = 50
    let scrollView = UIScrollView()
    var stack: AnimatedVStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func scrollViewToTextField(index: Int) {
        let stackHeight = stack.frame.size.height
        let textFieldFrameInWindow = stack.arrangedSubviews[index].convert(stack.arrangedSubviews[index].bounds, to: view.window)
        let textFieldOriginY = textFieldFrameInWindow.origin.y
        let textFieldHeight = textFieldFrameInWindow.size.height
        let textFieldLowpoint = textFieldOriginY + textFieldHeight
        let distanceFromBottomToTextField = scrollView.frame.size.height - textFieldLowpoint - scrollView.contentInset.bottom
                
        if distanceFromBottomToTextField < keyboardHeight ?? 0 {
            scrollView.contentInset.bottom = (keyboardHeight ?? 0) - distanceFromBottomToTextField
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.scrollView.contentOffset.y = -(self?.view.safeAreaInsets.top ?? 0) + (self?.keyboardHeight ?? 0) - distanceFromBottomToTextField
            }
        }
    }
    
    //MARK: - keyboard related
    
    @objc
    func keyboardDidShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        keyboardHeight = keyboardFrame.size.height
        guard !isKeyBoardOnScreen else {
            return
        }
        isKeyBoardOnScreen = true
        for (i, arrangedSubview) in stack.arrangedSubviews.enumerated() {
            if let textView = arrangedSubview as? TextFieldViewWithValidationAndTitle {
                if textView.textField.isFirstResponder {
                    scrollViewToTextField(index: i)
                }
            }
        }
    }
    
    @objc
    func keyboardDidHide() {
        isKeyBoardOnScreen = false
        resetScrollviewInsets()
    }
    
    func resetScrollviewInsets() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.scrollView.contentInset.bottom = 0
            self?.scrollView.contentOffset.y = -(self?.view.safeAreaInsets.top ?? 0)
        }
    }
    
    @objc
    func resignKeyboardResponder() {
        stack.arrangedSubviews.forEach {
          _ = ($0 as? TextFieldViewWithValidationAndTitle)?.resignFirstResponder()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
