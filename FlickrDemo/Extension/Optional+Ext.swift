import Foundation

extension Optional where Wrapped == String {
    
    public var isNilOrEmpty: Bool {
        guard let string = self else { return true }
        return string.isEmpty
    }
}
