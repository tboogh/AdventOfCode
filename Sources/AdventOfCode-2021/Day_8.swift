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
        var total = 0
        var count = 0
        for line in lines {
            let numberLine = line.components(separatedBy: " | ")
            let outputNumbers = numberLine[1].components(separatedBy: .whitespaces)
            let number = Number.make(input: numberLine[0])
            let validCombinations = number.findValidCombination()
            var numbers = [Int]()

            for validCombination in validCombinations {
                numbers = []
                for outputNumber in outputNumbers {
                    if let number = validCombination.toInt(input: outputNumber) {
                        numbers.append(number)
                    } else {
                        numbers = []
                        continue
                    }
                }
                if numbers.count == outputNumbers.count {
                    break
                }
            }
            if numbers.count != outputNumbers.count {
                continue
            }
            var multiplier = 1
            var result = 0
            for number in numbers.reversed() {
                result = result + (number * multiplier)
                multiplier *= 10
            }
            total += result
            count += 1
        }
        if count != lines.count {
            return -1
        }
        return total
    }
}

class Number {

    //     aaaa
    //    b    c
    //    b    c
    //     dddd
    //    e    f
    //    e    f
    //     gggg

    init() { }

    var a = Set<String>()
    var b = Set<String>()
    var c = Set<String>()
    var d = Set<String>()
    var e = Set<String>()
    var f = Set<String>()
    var g = Set<String>()
}

extension Number {

    static func make(a: String, b: String, c: String, d: String, e: String, f: String, g: String) -> Number {
        let number = Number()
        number.a.formUnion([a])
        number.b.formUnion([b])
        number.c.formUnion([c])
        number.d.formUnion([d])
        number.e.formUnion([e])
        number.f.formUnion([f])
        number.g.formUnion([g])
        return number
    }

    static func make(input: String) -> Number {
        let numberCombinations = input.components(separatedBy: " ").sorted { $0.count < $1.count }
        let number = Number()
        for numberCombination in numberCombinations {
            let numberCombinationSet = Set(numberCombination.map { String($0) } )
            switch numberCombination.count {
            case 2: // 1
                number.c.formUnion(numberCombinationSet)
                number.f.formUnion(numberCombinationSet)
            case 3: // 7
                let taken = number.setForNumber(3)
                let left = numberCombinationSet.subtracting(taken)
                number.a.formUnion(left)
            case 4: // 4
                let taken = number.setForNumber(4)
                let left = numberCombinationSet.subtracting(taken)
                number.b.formUnion(left)
                number.d.formUnion(left)
            case 5: // 2, 3, 5
                let taken = number.setForNumber(5)
                let left = numberCombinationSet.subtracting(taken)
                number.e.formUnion(left)
                number.g.formUnion(left)
            case 6: // 6 = 0, 6, 9
                let taken = number.setForNumber(6)
                let left = numberCombinationSet.subtracting(taken)
                number.e.formUnion(left)
                number.g.formUnion(left)
            case 7: // 8 = 7
                //??????
                break
            default:
                break
            }
        }
        return number
    }

    func findValidCombination() -> [Number] {
        var possible = [Number]()
        for _a in a {
            let remainingB = b.subtracting([_a])
            for _b in remainingB {
                let remainingC = c.subtracting([_a, _b])
                for _c in remainingC {
                    let remainingD = d.subtracting([_a, _b, _c])
                    for _d in remainingD {
                        let remainingE = e.subtracting([_a, _b, _c, _d])
                        for _e in remainingE {
                            let remainingF = f.subtracting([_a, _b, _c, _d, _e])
                            for _f in remainingF {
                                let remainingG = g.subtracting([_a, _b, _c, _d, _e, _f])
                                for _g in remainingG {
                                    let input = _a + _b + _c + _d + _e + _f + _g
                                    if isValid(input: input) {
                                        possible.append(Number.make(a: _a, b: _b, c: _c, d: _d, e: _e, f: _f, g: _g))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return possible
    }



    func toInt(input: String) -> Int? {
        let values = Set(input.map { String($0) })
        let aValue = a.intersection(values).hasContent
        let bValue = b.intersection(values).hasContent
        let cValue = c.intersection(values).hasContent
        let dValue = d.intersection(values).hasContent
        let eValue = e.intersection(values).hasContent
        let fValue = f.intersection(values).hasContent
        let gValue = g.intersection(values).hasContent

        //     aaaa
        //    b    c
        //    b    c
        //     dddd
        //    e    f
        //    e    f
        //     gggg
        //

        switch (aValue, bValue, cValue, dValue, eValue, fValue, gValue){
        case (false, false, true, false, false, true, false):
            return 1
        case (true, false, true, true, true, false, true):
            return 2
        case (true, false, true, true, false, true, true):
            return 3
        case (false, true, true, true, false, true, false):
            return 4
        case (true, true, false, true, false, true, true):
            return 5
        case (true, true, false, true, true, true, true):
            return 6
        case (true, false, true, false, false, true, false):
            return 7
        case (true, true, true, true, true, true, true):
            return 8
        case (true, true, true, true, false, true, true):
            return 9
        case (true, true, true, false, true, true, true):
            return 0

        default:
            return nil
        }
    }

    func setForNumber(_ number: Int) -> Set<String> {
        switch number {
        case 3:
            return Set(Array(c) + Array(f))
        case 4:
            return Set(Array(a) + Array(c) + Array(f))
        case 5:
            return Set(Array(a) + Array(b) + Array(c) + Array(d) + Array(f))
        case 6:
            return Set(Array(a) + Array(b) + Array(c) + Array(d) + Array(f))
        default:
            return Set()
        }
    }

    func createDict(_ input: [String]) -> [String: String] {
        let key = "abcdefg".map { String($0) }
        let zipped = Array(zip(key, input))
        let dict = Dictionary(uniqueKeysWithValues: zipped)
        return dict
    }

    func isValid(input: String) -> Bool {
        let components = input.map { String($0) }
        let dict = createDict(components)
        let isOneValid = isOne(dict)
        let isTwoValid = isTwo(dict)
        let isThreeValid = isThree(dict)
        let isFourValid = isFour(dict)
        let isFiveValid = isFive(dict)
        let isSixValid = isSix(dict)
        let isSevenValid = isSeven(dict)
        let isEightValid = isEight(dict)
        let isNineValid = isNine(dict)
        let isZeroValid = isZero(dict)
        return isOneValid &&
               isTwoValid &&
               isThreeValid &&
               isFourValid &&
               isFiveValid &&
               isSixValid &&
               isSevenValid &&
               isEightValid &&
               isNineValid &&
               isZeroValid
    }

    //     ....
    //    .    c
    //    .    c
    //     ....
    //    .    f
    //    .    f
    //     ....
    func isOne(_ dict: [String:String]) -> Bool {
        guard
            let cValue = dict["c"],
            let fValue = dict["f"]
        else { return false }
        return c.contains(cValue) && f.contains(fValue)
    }

    //     aaaa
    //    .    c
    //    .    c
    //     dddd
    //    e    .
    //    e    .
    //     gggg
    func isTwo(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let cValue = dict["c"],
            let dValue = dict["d"],
            let eValue = dict["e"],
            let fValue = dict["f"]
        else { return false }
        return a.contains(aValue) && c.contains(cValue) && d.contains(dValue) && e.contains(eValue) && f.contains(fValue)
    }

    //     aaaa
    //    .    c
    //    .    c
    //     dddd
    //    .    f
    //    .    f
    //     gggg
    func isThree(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let cValue = dict["c"],
            let dValue = dict["d"],
            let fValue = dict["f"],
            let gValue = dict["g"]
        else { return false }
        return a.contains(aValue) && c.contains(cValue) && d.contains(dValue) && f.contains(fValue) && g.contains(gValue)
    }

    //     ....
    //    b    c
    //    b    c
    //     dddd
    //    .    f
    //    .    f
    //     ....
    func isFour(_ dict: [String:String]) -> Bool {
        guard
            let bValue = dict["b"],
            let cValue = dict["c"],
            let dValue = dict["d"],
            let fValue = dict["f"]
        else { return false }
        return b.contains(bValue) && c.contains(cValue) && d.contains(dValue) && f.contains(fValue)
    }

    //     aaaa
    //    b    .
    //    b    .
    //     dddd
    //    .    f
    //    .    f
    //     gggg
    func isFive(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let bValue = dict["b"],
            let dValue = dict["d"],
            let fValue = dict["f"],
            let gValue = dict["g"]
        else { return false }
        return a.contains(aValue) && b.contains(bValue) && d.contains(dValue) && f.contains(fValue) && g.contains(gValue)
    }

    //     aaaa
    //    b    .
    //    b    .
    //     dddd
    //    e    f
    //    e    f
    //     gggg
    func isSix(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let bValue = dict["b"],
            let dValue = dict["d"],
            let eValue = dict["e"],
            let fValue = dict["f"],
            let gValue = dict["g"]
        else { return false }
        return a.contains(aValue) && b.contains(bValue) && d.contains(dValue) && e.contains(eValue) && f.contains(fValue) && g.contains(gValue)
    }

    //     aaaa
    //    .    c
    //    .    c
    //     ....
    //    .    f
    //    .    f
    //     ....
    func isSeven(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let cValue = dict["c"],
            let fValue = dict["f"]
        else { return false }
        return a.contains(aValue) && c.contains(cValue) && f.contains(fValue)
    }

    //     aaaa
    //    b    c
    //    b    c
    //     dddd
    //    e    f
    //    e    f
    //     gggg
    func isEight(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let bValue = dict["b"],
            let cValue = dict["c"],
            let dValue = dict["d"],
            let eValue = dict["e"],
            let fValue = dict["f"],
            let gValue = dict["g"]
        else { return false }
        return a.contains(aValue) && b.contains(bValue) && c.contains(cValue) && d.contains(dValue) && e.contains(eValue) && f.contains(fValue) && g.contains(gValue)
    }

    //     aaaa
    //    b    c
    //    b    c
    //     dddd
    //    .    f
    //    .    f
    //     gggg
    func isNine(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let bValue = dict["b"],
            let cValue = dict["c"],
            let dValue = dict["d"],
            let fValue = dict["f"],
            let gValue = dict["g"]
        else { return false }
        return a.contains(aValue) && b.contains(bValue) && c.contains(cValue) && d.contains(dValue) && f.contains(fValue) && g.contains(gValue)
    }

    func isZero(_ dict: [String:String]) -> Bool {
        guard
            let aValue = dict["a"],
            let bValue = dict["b"],
            let cValue = dict["c"],
            let eValue = dict["e"],
            let fValue = dict["f"],
            let gValue = dict["g"]
        else { return false }
        return a.contains(aValue) && b.contains(bValue) && c.contains(cValue) && e.contains(eValue) && f.contains(fValue) && g.contains(gValue)
    }
}

extension Collection {

    var hasContent: Bool {
        !isEmpty
    }
}
