public extension Sequence where Element == Int {

    func sum() -> Int {
        self.reduce(0, +)
    }
}
