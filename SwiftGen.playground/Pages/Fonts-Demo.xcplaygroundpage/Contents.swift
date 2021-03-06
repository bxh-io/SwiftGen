//: #### Other pages
//: * [Demo for `swiftgen strings`](Colors-Demo)
//: * [Demo for `swiftgen images`](Images-Demo)
//: * [Demo for `swiftgen storyboards`](Storyboards-Demo)
//: * [Demo for `swiftgen colors`](Colors-Demo)
//: * Demo for `swiftgen fonts`

//: #### Example of code generated by swiftgen-fonts

import UIKit.UIFont

protocol FontConvertible {
    func font(size: CGFloat) -> UIFont!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
    func font(size: CGFloat) -> UIFont! {
        return UIFont(font: self, size: size)
    }
}

extension UIFont {
    convenience init!<FontType: FontConvertible>
        (font: FontType, size: CGFloat)
        where FontType: RawRepresentable, FontType.RawValue == String {
            self.init(name: font.rawValue, size: size)
    }
}

struct FontFamily {
    enum Helvetica: String, FontConvertible {
        case regular = "Helvetica"
        case bold = "Helvetica-Bold"
    }
    enum HelveticaNeue: String, FontConvertible {
        case regular = "HelveticaNeue"
        case bold = "HelveticaNeue-Bold"
    }
}

//: #### Usage Example
// Using the UIFont constructor…
let helvetica = UIFont(font: FontFamily.Helvetica.regular, size: 20.0)
// Or using the enum value and its `font` method
let helveticaNeue = FontFamily.HelveticaNeue.regular.font(size: 20.0)

let helveticaBoldBig = FontFamily.Helvetica.bold.font(size: 100.0)
let helveticaNeueBoldSmall = UIFont(font: FontFamily.HelveticaNeue.bold, size: 8.0)
