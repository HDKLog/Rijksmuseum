import UIKit

struct DesignBookColor: Hashable {
    private let name: String

    public init(name: String) {
        self.name = name
    }

    var uiColor: UIColor { UIColor(named: name)! }
    var cgColor: CGColor { uiColor.cgColor }
}
