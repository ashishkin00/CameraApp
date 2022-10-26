extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
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

enum FlashModes: String, CaseIterable {
    case auto = "bolt.badge.a.fill", on = "bolt.fill", off = "bolt.slash.fill"
}
