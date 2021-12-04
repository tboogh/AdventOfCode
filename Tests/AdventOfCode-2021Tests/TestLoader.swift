import Foundation
import XCTest

extension XCTestCase {
    
    func loadTestData(filename: String) -> [String] {
        guard let configURL = Bundle.module.url(forResource: filename, withExtension: "txt"),
              let fileData = try? String(contentsOf: configURL) else {
            assertionFailure("Could not load file \(filename)")
            return []
        }
        return fileData.components(separatedBy: "\n")
    }
}
