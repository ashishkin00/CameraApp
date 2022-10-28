import UIKit
import AVFoundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}

extension Array where Element: Equatable {
    func nextItem(after: Element) -> Element? {
        if let index = self.firstIndex(of: after), index + 1 < self.count {
            return self[index + 1]
        }
        return self.first
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImageView {
    open override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        let margin: CGFloat = 5
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}

extension Comparable {
    func clamped(_ f: Self, _ t: Self)  ->  Self {
        var r = self
        if r < f { r = f }
        if r > t { r = t }
        return r
    }
}

enum CameraPosition: CaseIterable {
    case front, back
}

enum CameraModule: CaseIterable {
    case wideAngleCamera, some
}

enum FlashModes: String, CaseIterable {
    case auto = "bolt.badge.a.fill", on = "bolt.fill", off = "bolt.slash.fill"
}
