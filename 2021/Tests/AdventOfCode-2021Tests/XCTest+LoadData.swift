import XCTest
import AdventOfCodeCommon

public extension XCTestCase {

    func loadTestData(filename: String) -> [String] {
        guard let fileUrl = Bundle.module.url(forResource: filename, withExtension: "txt") else {
            fatalError("Could not get fileUrl")
        }
        return DataLoader.loadTestData(fileUrl: fileUrl)
    }

    func loadTest(filename: String) -> String {
        guard let fileUrl = Bundle.module.url(forResource: filename, withExtension: "txt") else {
            fatalError("Could not get fileUrl")
        }
        return DataLoader.loadTest(fileUrl: fileUrl)
    }
}
