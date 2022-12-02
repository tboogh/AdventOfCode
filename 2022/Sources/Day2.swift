import AdventOfCodeCommon

public struct Day2 {

    public init() {}

    public struct Move: Hashable {

        public let points: Int

        public static let rock = Move(points: 1)
        public static let paper = Move(points: 2)
        public static let scissor = Move(points: 3)
    }

    public enum RoundScore: Int {
        case lost = 0
        case draw = 3
        case win = 6
    }

    public struct Round {

        let playerMove: Move
        let elfMove: Move

        func score(rules: [Move: Move]) -> Int {
            if playerMove == elfMove {
                return RoundScore.draw.rawValue + playerMove.points
            }
            let playerMoveBeats = rules[playerMove]
            if playerMoveBeats == elfMove {
                return RoundScore.win.rawValue + playerMove.points
            }
            return RoundScore.lost.rawValue + playerMove.points
        }
    }

    public struct Game {

        public init() {}

        public let elfMap: [String: Move] = [
            "A": .rock,
            "B": .paper,
            "C": .scissor
        ]

        public let playerMap: [String: Move] = [
            "X": .rock,
            "Y": .paper,
            "Z": .scissor
        ]

        public let roundEndMap: [String: RoundScore] = [
            "X": .lost,
            "Y": .draw,
            "Z": .win
        ]

        public let moveBeatsMoveRules: [Move: Move] = [
            .paper: .rock,
            .rock: .scissor,
            .scissor: .paper,
        ]

        public var winningMoveForMove: [Move: Move] = [
            .rock: .paper,
            .scissor: .rock,
            .paper: .scissor,
        ]

        public func roundsForInput(input: [String], transform: ((Move, String) -> Move)? = nil) -> [Round] {
            let rounds = input.map { $0.split(whereSeparator: \.isWhitespace) }
                .map { input in
                    let elf = String(input[0])
                    let player = String(input[1])
                    let elfMove = elfMap[elf]!
                    var playerMove = playerMap[player]!
                    if let transform {
                        playerMove = transform(elfMove, player)
                    }
                    return Round(playerMove: playerMove, elfMove: elfMove)
                }
            return rounds
        }

        public func totalScoreForRounds(rounds: [Round], rules: [Move: Move]) -> Int {
            rounds.map { $0.score(rules: rules) }.reduce(0, +)
        }

        public func roundForInput2(input: [String]) -> [Round] {
            roundsForInput(input: input) { elf, roundEndRaw in
                let roundEnd = roundEndMap[roundEndRaw]
                switch roundEnd {
                case .draw:
                    return elf
                case .win: return winningMoveForMove[elf]!
                case .lost: return moveBeatsMoveRules[elf]!
                case .none: fatalError("You got it wrong dude!") }
                return .paper
            }
        }
    }
}
