public class Day_1{
    
    func partOne(input: [Int]) -> Int? {
        
        var increases = 0
        for index in 0..<input.count {
            if index == 0 {
                continue
            }
            increases += (input[index] - input[index - 1] > 0) ? 1 : 0
        }
        return increases
    }


    /*
     0 1 2 3 4 5 6 7
     0  A
     1  A B
     2  A B C
     3    B C D
     4      C D E
     5        D E F
     6          E F G
     7            F G H
     8              G H
     9                H
     */


    func partTwo(input: [Int]) -> Int? {
        var increases = 0
        var windows = Array(repeating: 0, count: input.count)
        var values = Array(repeating: 0, count: input.count)
        
        for index in 0..<input.count {
            let lowerIndex = lowerIndex(index)
            for innerIndex in lowerIndex...index {
                let inputValue = input[index]
                windows[innerIndex] += 1
                values[innerIndex] += inputValue
            }
        }
        
        for windowIndex in 0..<windows.count {
            guard
                windowIndex > 0,
                windows[windowIndex] == 3
            else { continue }
            increases += (values[windowIndex] - values[windowIndex - 1] > 0) ? 1 : 0
        }
        return increases
    }
    
    func lowerIndex(_ index: Int) -> Int {
        let lowerIndex = index - 2
        return max(0, lowerIndex)
    }
}
