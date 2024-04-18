import UIKit

extension UIColor {
    static let primaryColor = UIColor(named: "PrimaryColor")!
    static let backgroundColor = UIColor(named: "BackgroundColor")!
    static let lightBackgroundColor = UIColor(named: "LightBackgroundColor")!
    static let alertsInformationColor = UIColor(named: "AlertsInformation")!
    static let alertsRedColor = UIColor(named: "AlertsRed")!
    static let alertsBackgroundColor = UIColor(named: "AlertsBackground")
    static let secondaryColor = UIColor(named: "SecondaryColor")!
    static let disabledGray = UIColor(named: "GrayDisabled")!
    static let disabledGrayBackground = UIColor(named: "GrayDisabledBackground")!
    static let grayGhost = UIColor(named: "GrayGhost")!
    static let lightGray = UIColor(named: "LightGray")!
    static let charcoalColor = UIColor(named: "CharcoalColor")!
    static let tertiaryColor = UIColor(named: "TertiaryColor")!
    static let textfieldFocusColor = UIColor(named: "TextfieldFocusColor")!
    static let yellowColor = UIColor(named: "YellowColor")!
    static let dividerColor = UIColor(named: "Divider")!
    static let textColor = UIColor(named: "TextColor")!
    static let supportBlueColor = UIColor(named: "SupportBlueColor")!
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
