//
//  UIColor+additions.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 05/04/2022.
//

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        var hexa = hex
        if hexa.count == 7 {
            hexa = hexa + "FF"
        }
        
        if hexa.hasPrefix("#") {
            let start = hexa.index(hexa.startIndex, offsetBy: 1)
            let hexColor = String(hexa[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
