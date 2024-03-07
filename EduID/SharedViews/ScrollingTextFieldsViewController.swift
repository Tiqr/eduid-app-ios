import UIKit

class ScrollingTextFieldsViewController: BaseViewController {

    private var keyboardHeight: CGFloat?
    private var isKeyBoardOnScreen = false
    static let smallBuffer: CGFloat = 50
    let scrollView = UIScrollView()
    var stack: AnimatedVStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func scrollViewToTextField(index: Int) {
        let textFieldFrameInWindow = stack.arrangedSubviews[index].convert(stack.arrangedSubviews[index].bounds, to: view.window)
        let textFieldOriginY = textFieldFrameInWindow.origin.y
        let textFieldHeight = textFieldFrameInWindow.size.height
        let textFieldLowpoint = textFieldOriginY + textFieldHeight
        let distanceFromBottomToTextField = scrollView.frame.size.height - textFieldLowpoint
        let keyboardHeight = keyboardHeight ?? 0
        if distanceFromBottomToTextField < keyboardHeight {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else {
                    return
                }
                let currentOffset = self.scrollView.contentOffset.y
                let halfScreenSize = (self.view.frame.height + self.view.safeAreaInsets.top - keyboardHeight) / 2
                let targetOffset = currentOffset + (keyboardHeight - distanceFromBottomToTextField) + halfScreenSize
                let maxOffset = self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom
                if targetOffset > maxOffset {
                    self.scrollView.contentOffset.y = maxOffset
                } else {
                    self.scrollView.contentOffset.y = targetOffset
                }
                
            }
        }
    }
    
    //MARK: - keyboard related
    
    @objc
    func keyboardFrameChanged(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        keyboardHeight = keyboardFrame.size.height
        guard isKeyBoardOnScreen else {
            return
        }
        scrollView.contentInset.bottom = keyboardHeight ?? 0 + scrollView.safeAreaInsets.bottom
    }
    
    @objc
    func keyboardDidShow(notification: Notification) {
        isKeyBoardOnScreen = true
        keyboardFrameChanged(notification: notification)
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
