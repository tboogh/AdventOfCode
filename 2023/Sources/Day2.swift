import AdventOfCodeCommon
import Foundation

public struct Day2 {
    
    public static func partOne(input: [String]) -> Int {
        let games = input.map { Game(data: $0) }
        let values = games.map { $0.validate(allowedRed: 12, allowedGreen: 13, allowedBlue: 14)}
        return values.sum()
    }
    
    public static func partTwo(input: [String]) -> Int {
        let games = input.map { Game(data: $0) }
        let maxvalues = games.map { $0.fewestNeeded() }.map { $0.red * $0.blue * $0.green }
        return maxvalues.sum()
    }
}

private struct Game {
    
    let index: Int
    let rounds: [Round]
    
    init(data: String) {
        let gameData = data.components(separatedBy: ": ")
        let gameInfo = gameData[0].components(separatedBy: " ")
        let roundIndo = gameData[1].components(separatedBy: "; ")
        if let gameNumberCharacter = gameInfo.last,
            let gameNumber = Int(String(gameNumberCharacter)){
            index = gameNumber
        } else {
            index = 0
        }
        rounds = roundIndo.map { Round(data: $0)}
    }

    func validate(allowedRed: Int, allowedGreen: Int, allowedBlue: Int) -> Int {
        if rounds.allSatisfy({
            let result = $0.validate(allowedRed: allowedRed, allowedBlue: allowedBlue, allowedGreen: allowedGreen)
            return result
        }) {
            return index
        }
        return 0
    }

    func fewestNeeded() -> (red: Int, blue: Int, green: Int) {
        var maxRed = 0
        var maxBlue = 0
        var maxGreen = 0
        for round in rounds {
            maxRed = max(round.red, maxRed)
            maxBlue = max(round.blue, maxBlue)
            maxGreen = max(round.green, maxGreen)
        }
        return (maxRed, maxBlue, maxGreen)
    }
}

private struct Round {
    
    init(data: String) {
        let colorData = data.components(separatedBy: ", ")
        var red = 0
        var blue = 0
        var green = 0
        for colorDataRow in colorData {
            let rowValues = colorDataRow.components(separatedBy: " ")
            if colorDataRow.contains("red"),
               let character = rowValues.first {
                if let value = Int(String(character)) {
                    red = value
                }
            }
            if colorDataRow.contains("green"),
               let character = rowValues.first {
                if let value = Int(String(character)) {
                    green = value
                }
            }
            if colorDataRow.contains("blue"),
               let character = rowValues.first {
                if let value = Int(String(character)) {
                    blue = value
                }
            }
        }
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    let red: Int
    let green: Int
    let blue: Int

    func validate(allowedRed: Int, allowedBlue: Int, allowedGreen: Int) -> Bool {
        let validRed = red <= allowedRed
        let validGreen = green <= allowedGreen
        let validBlue = blue <= allowedBlue
        let allValid = validRed && validGreen && validBlue
        return allValid
    }
}
