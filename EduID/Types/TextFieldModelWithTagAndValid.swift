import Foundation

struct TextFieldModelWithTagAndValid {
    var tag: Int
    var text: String
    var isValid: Bool
    
    static var empty: TextFieldModelWithTagAndValid {
        return TextFieldModelWithTagAndValid(tag: -1, text: "", isValid: false)
    }
}
