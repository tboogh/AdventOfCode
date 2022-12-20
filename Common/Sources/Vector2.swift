public struct Vector2: Equatable {

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public let x: Float
    public let y: Float

    public static let zero = Vector2(x: 0, y: 0)
}
