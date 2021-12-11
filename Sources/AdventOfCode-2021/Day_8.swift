/*

 0:      1:      2:      3:      4:
  aaaa    ....    aaaa    aaaa    ....
 b    c  .    c  .    c  .    c  b    c
 b    c  .    c  .    c  .    c  b    c
  ....    ....    dddd    dddd    dddd
 e    f  .    f  e    .  .    f  .    f
 e    f  .    f  e    .  .    f  .    f
  gggg    ....    gggg    gggg    ....

 5:      6:      7:      8:      9:
  aaaa    aaaa    aaaa    aaaa    aaaa
 b    .  b    .  .    c  b    c  b    c
 b    .  b    .  .    c  b    c  b    c
  dddd    dddd    ....    dddd    dddd
 .    f  e    f  .    f  e    f  .    f
 .    f  e    f  .    f  e    f  .    f
  gggg    gggg    ....    gggg    gggg
 */

typealias Signal = [String: String]

extension Signal {

    static var `default`: Signal { ["a": ".",
                                    "b": ".",
                                    "c": ".",
                                    "d": ".",
                                    "e": ".",
                                    "f": ".",
                                    "g": "."] }

    func debugPrint() {
        let a = self["a"] ?? "."
        let b = self["b"] ?? "."
        let c = self["c"] ?? "."
        let d = self["d"] ?? "."
        let e = self["e"] ?? "."
        let f = self["f"] ?? "."
        let g = self["g"] ?? "."
        print(debugString)
    }


    var debugString: String {
        let a = self["a"] ?? "."
        let b = self["b"] ?? "."
        let c = self["c"] ?? "."
        let d = self["d"] ?? "."
        let e = self["e"] ?? "."
        let f = self["f"] ?? "."
        let g = self["g"] ?? "."
        return "\(a)\(b)\(c)\(d)\(e)\(f)\(g)"
    }
}

public class Day_8 {

    func partOne(input: String) -> Int {
        let lines = input
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: " | ")[1] }

        var totalCount = 0
        for line in lines {
            let components = line.components(separatedBy: " ")
            let rowCount = components.reduce(into: 0, { $0 += count($1)})
            totalCount += rowCount
            print("\(rowCount) \(line)")
        }
        return totalCount
    }

    func count(_ input: String) -> Int {
        let count = input.count
        switch count {
        case 2, 4, 3, 7:
            return 1
        default:
            return 0
        }
    }


    func partTwo(input: String) -> Int {
        let lines = input
            .components(separatedBy: .newlines)

        var totalCount = 0
        for line in lines {
            let parts = line.components(separatedBy: " | ")
            let inputs = parts[0].components(separatedBy: .whitespaces)
                .sorted(by: { $0.count < $1.count })
                .map { Array($0).map { String($0) } }
            let output = parts[1]

            var possibleSignals = [Signal]()
            for input in inputs {
                let inputSet = Set(input)
                switch input.count {
                case 2:
                    let values = permute(list: input)
                    let combos = ["cf"].flatMap { d in values.map { (Array(d), Array($0)) }}
                        .map { combo -> Signal in
                            let keyValueMap = zip(combo.0, combo.1)
                            var signal = Signal.default
                            for keyValue in keyValueMap {
                                signal[String(keyValue.0)] = String(keyValue.1)
                            }
                            return signal
                        }
                    possibleSignals = combos
                    break
                case 3:
                    possibleSignals = possibleSignals.map { signal -> Signal in
                        let values = Set(signal.values.compactMap { $0 })
                        let newValues = Array(inputSet.subtracting(values))
                        var updated = signal
                        updated["a"] = newValues[0]
                        return updated
                    }
                case 4:
                    let newSignals2 = possibleSignals.map { signal -> [Signal] in
                        let values = Set(signal.values.compactMap { $0 })
                        let newValues = Array(inputSet.subtracting(values))
                        let m = ["bc"].flatMap { d in newValues.map { (Array(d), Array($0)) }}
                        let combos = m
                            .map { combo -> Signal in
                                let keyValueMap = zip(combo.0, combo.1)
                                var newSignal = signal
                                for keyValue in keyValueMap {
                                    newSignal[String(keyValue.0)] = String(keyValue.1)
                                }
                                return newSignal
                            }
                        return combos
                    }.flatMap { $0 }

                    let newSignals = possibleSignals.map { signal -> [Signal] in
                        let values = Set(signal.values.compactMap { $0 })
                        let newValues = Array(inputSet.subtracting(values))
                        let newSignals = permute(list: newValues)
                            .map { Array($0) }
                            .map { input -> Signal in
                                var newSignal = signal
                                newSignal["b"] = String(input[0])
                                newSignal["c"] = String(input[1])
                                return newSignal
                            }
                        
                        return newSignals
                    }.flatMap{ $0 }

                    newSignals.forEach { $0.debugPrint() }
                    newSignals2.forEach { $0.debugPrint() }
                    possibleSignals = newSignals
                case 5:
                    let newSignals = possibleSignals.map { signal -> [Signal] in
                        let values = Set(signal.values.compactMap { $0 })
                        let newValues = Array(inputSet.subtracting(values))
                        let emptyKeys = signal.filter { row in
                            row.value == "."
                        }.keys.sorted()
                        let combo = [emptyKeys].flatMap { d in newValues.map { (Array(d), Array($0)) }}
                        print(combo)
                        let keycombo = permute(list: Array(emptyKeys), minStringLen: emptyKeys.count)
                        return []

//                        let newSignals = permute(list: newValues)
//                            .map { Array($0) }
//                            .map { input -> [Signal] in
//                                let emptyKeys = signal.filter { row in
//                                    row.value == "."
//                                }.keys
//                                var newSignal = signal
//                                switch newValues.count {
//                                case 1:
//                                    for key in emptyKeys {
//                                        newSignal[key] = newValues[0]
//                                    }
//                                    return [newSignal]
//                                default:
//                                    break
//                                }
//                                let permKeys = permute(list: Array(emptyKeys), minStringLen: emptyKeys.count)
//
//                                print(permKeys)
//
//                                return [newSignal]
//                            }

//                        return newSignals.flatMap { $0 }
                    }.flatMap{ $0 }

                    possibleSignals = newSignals
                default:
                    break
                }
            }

        }
        return totalCount
    }

}

/*
 aaaa
b    c
b    c
 dddd
e    f
e    f
 gggg

 aaaa
b    c
b    c
 dddd
.    f
.    f
 ....

 */


func permute(list: [String], minStringLen: Int = 2) -> Set<String> {
    func permute(fromList: [String], toList: [String], minStringLen: Int, set: inout Set<String>) {
        if toList.count >= minStringLen {
            set.insert(toList.joined(separator: ""))
        }
        if !fromList.isEmpty {
            for (index, item) in fromList.enumerated() {
                var newFrom = fromList
                newFrom.remove(at: index)
                permute(fromList: newFrom, toList: toList + [item], minStringLen: minStringLen, set: &set)
            }
        }
    }

    var set = Set<String>()
    permute(fromList: list, toList:[], minStringLen: minStringLen, set: &set)
    return set
}
