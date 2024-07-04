import UIKit

enum DesignBook {
    enum Image { }

    enum Color {

        enum Background {
            static let main = DesignBookColor(name: "color-background-main")
            static let list = DesignBookColor(name: "color-background-list")
            static let inverse = DesignBookColor(name: "color-background-inverse")
            static let light = DesignBookColor(name: "color-background-light")
        }

        enum Foreground {
            static let highlighted = DesignBookColor(name: "color-foreground-highlited")
            static let action = DesignBookColor(name: "color-foreground-action")
            static let element = DesignBookColor(name: "color-foreground-element")
            static let inverse = DesignBookColor(name: "color-foreground-inverse")
            static let light = DesignBookColor(name: "color-foreground-light")

            static let purple = DesignBookColor(name: "color-foreground-purple")
            static let orange = DesignBookColor(name: "color-foreground-orange")
            static let green = DesignBookColor(name: "color-foreground-green")
            static let blue = DesignBookColor(name: "color-foreground-blue")
            static let yellow = DesignBookColor(name: "color-foreground-yellow")
            static let red = DesignBookColor(name: "color-foreground-red")
        }
    }

    enum Layout {

        struct Sizes {
            enum Image {
                static let small: CGFloat = 125
                static let medium: CGFloat = 250
                static let large: CGFloat = 600
            }

            struct Text {
                struct Font {
                    static let small: CGFloat = 16
                    static let medium: CGFloat = 18
                    static let large: CGFloat = 22
                }

                struct Header {
                    static let small: CGFloat = 32
                    static let medium: CGFloat = 64
                    static let large: CGFloat = 128
                }
            }
        }

        enum Spacing {
            static let small: CGFloat = 5
            static let medium: CGFloat = 10
            static let large: CGFloat = 30
        }
    }
}
