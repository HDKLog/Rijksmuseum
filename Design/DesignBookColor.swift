import UIKit

struct DesignBookColor {
    private let name: String

    public init(name: String) {
        self.name = name
    }

    var uiColor: UIColor { UIColor(named: name)! }
}
