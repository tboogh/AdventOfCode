import XCTest
@testable import AdventOfCode_2021

final class TestDay_Day13: XCTestCase {

    func testExamplePartOne() {
        let input = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""
        let day = Day_13()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 17)
    }

    func testComputePartOne() {
        let input = loadTest(filename: "Day13")
        let day = Day_13()
        let result = day.partOne(input: input)
        XCTAssertEqual(result, 781)
    }

    func testExamplePartTwo() {
        let input = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""
        let day = Day_13()
        let result = day.partTwo(input: input)

        /*
         #####
         #   #
         #   #
         #   #
         #####

         O
         */
        XCTAssertEqual(result, 16)
    }

    func testComputePartTwo() {
        let input = loadTest(filename: "Day13")
        let day = Day_13()
        let result = day.partTwo(input: input)
        /*
         ###  #### ###   ##   ##    ## ###  ###
         #  # #    #  # #  # #  #    # #  # #  #
         #  # ###  #  # #    #       # #  # ###
         ###  #    ###  #    # ##    # ###  #  #
         #    #    # #  #  # #  # #  # #    #  #
         #    #### #  #  ##   ###  ##  #    ###

         PERCGJPB
         */

        XCTAssertEqual(result, 99)
    }
}

