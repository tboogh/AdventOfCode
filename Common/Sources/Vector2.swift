public struct Vector2<T> {

    public init(x: T, y: T) {
        self.x = x
        self.y = y
    }
    
    public let x: T
    public let y: T
}

public typealias IntVector2 = Vector2<Int>

extension IntVector2: Equatable, Hashable, CustomDebugStringConvertible {

    public var debugDescription: String {
        "(\(x), \(y))"
    }
}
