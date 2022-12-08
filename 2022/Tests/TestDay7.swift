import AdventOfCode_2022
import XCTest

final class TestDay7: XCTestCase {

    func testPart1_intro() {
        let data = """
                   $ cd /
                   $ ls
                   dir a
                   14848514 b.txt
                   8504156 c.dat
                   dir d
                   $ cd a
                   $ ls
                   dir e
                   29116 f
                   2557 g
                   62596 h.lst
                   $ cd e
                   $ ls
                   584 i
                   $ cd ..
                   $ cd ..
                   $ cd d
                   $ ls
                   4060174 j
                   8033020 d.log
                   5626152 d.ext
                   7214296 k
                   """.lines

        let result = Day7.partOne(input: data)

        XCTAssertEqual(result, 95437)
    }

    func testPart1_data() {
        let data = loadTestData(filename: "Day7")

        let result = Day7.partOne(input: data)

        XCTAssertEqual(result, 1743217)
    }

    func testPart2_intro() {
        let data = """
                   $ cd /
                   $ ls
                   dir a
                   14848514 b.txt
                   8504156 c.dat
                   dir d
                   $ cd a
                   $ ls
                   dir e
                   29116 f
                   2557 g
                   62596 h.lst
                   $ cd e
                   $ ls
                   584 i
                   $ cd ..
                   $ cd ..
                   $ cd d
                   $ ls
                   4060174 j
                   8033020 d.log
                   5626152 d.ext
                   7214296 k
                   """.lines

        let result = Day7.partTwo(input: data)

        XCTAssertEqual(result, 24933642)
    }

    func testPart2_data() {
        let data = loadTestData(filename: "Day7")

        let result = Day7.partTwo(input: data)

        XCTAssertEqual(result, 8319096)
    }
}
