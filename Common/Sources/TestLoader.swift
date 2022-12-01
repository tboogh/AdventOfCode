import Foundation

public class DataLoader {
    
    public static func loadTestData(fileUrl: URL) -> [String] {
        guard let fileData = try? String(contentsOf: fileUrl) else {
            assertionFailure("Could not load file at \(fileUrl)")
            return []
        }
        return fileData.components(separatedBy: "\n").filter { !$0.isEmpty }
    }

    public static func loadTest(fileUrl: URL) -> String {
        guard let fileData = try? String(contentsOf: fileUrl) else {
            assertionFailure("Could not load file at \(fileUrl)")
            return ""
        }
        return fileData
    }
}
