extension String {

    var rows: [String] {
        self
            .components(separatedBy: .newlines)
            .filter { $0.count > 0 }
    }

    var isLowercase: Bool {
        self == self.lowercased()
    }
}
