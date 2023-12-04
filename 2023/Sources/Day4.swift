import AdventOfCodeCommon
import Foundation

public struct Day4 {

    public static func partOne(input: [String]) -> Int {
        let rows = input.map { GameRow(data: $0) }
        let scores = rows.map { $0.getPoints() }
        return scores.sum()
    }

    public static func partTwo(input: [String]) -> Int {
        let rows = input.map { GameRow(data: $0) }
        let matchingNumbers = rows.map { ($0.round, $0.getMatchingNumbers()) }
        var copiesCount = [Int: Int]()

        func incrementCopyCount(round: Int, bonus: Int = 0) {
            var roundResult = copiesCount[round] ?? 0
            roundResult += 1 + bonus
            copiesCount[round] = roundResult
        }

        for (round, numbers) in matchingNumbers {
            let additionalMultiples = copiesCount[round] ?? 0
            incrementCopyCount(round: round)
            guard numbers.count > 0 else { continue }
            for index in 1...numbers.count {
                let goodGround = round + index
                incrementCopyCount(round: goodGround, bonus: additionalMultiples)
            }

        }
        let total = copiesCount.values.sum()
        return total
    }
}

struct GameRow {

    init(data: String) {
        let gameData = data.components(separatedBy: ": ")
        let numberData = gameData[1].components(separatedBy: " | ")

        let winningNumbers = WinningNumbers(data: numberData[0])
        let playedNumbers = PlayedNumbers(data: numberData[1])
        let cardData = gameData[0].components(separatedBy: .whitespaces)
        self.round = Int(cardData.last!)!
        self.winningNumbers = winningNumbers
        self.playedNumbers = playedNumbers
    }

    let round: Int
    let winningNumbers: WinningNumbers
    let playedNumbers: PlayedNumbers

    func getPoints() -> Int {
        let scoringNumbers = getMatchingNumbers()
        guard scoringNumbers.isEmpty == false else { return 0 }
        let multipleCount = scoringNumbers.count - 1
        if multipleCount == 0 {
             return 1
        }
        var score = 1
        for _ in 1...multipleCount {
            score *= 2
        }
        return score
    }

    func getMatchingNumbers() -> [Int] {
        let setOfPlayedNumbers = Set(playedNumbers.numbers)
        let setOfWinningNumbers = Set(winningNumbers.numbers)
        let scoringNumbers = setOfPlayedNumbers.intersection(setOfWinningNumbers)
        return Array(scoringNumbers)
    }
}

struct WinningNumbers {

    init(data: String) {
        let numbers = data.components(separatedBy: .whitespaces)
        self.numbers = numbers.compactMap { Int($0) }
    }

    let numbers: [Int]
}

struct PlayedNumbers {

    init(data: String) {
        let numbers = data.components(separatedBy: .whitespaces)
        self.numbers = numbers.compactMap { Int($0) }
    }

    let numbers: [Int]
}
