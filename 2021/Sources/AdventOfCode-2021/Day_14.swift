public class Day_14 {

    func partOne(input: String) -> Int {
        compute(input: input, iteration: 10)
    }

    func partTwo(input: String) -> Int {
        compute(input: input, iteration: 40)
    }

    func compute(input: String, iteration: Int) -> Int {
        let rows = input.lines
        let templateRow = rows[0]
        let pairInsertionRuleRows = rows.dropFirst().map{ Rule(input: $0) }

        let templateLinks = createLinks(input: templateRow)

        for _ in 0..<iteration {
            process(rules: pairInsertionRuleRows, link: templateLinks)
        }

        let result = templateLinks.toString()
        let sorted = result.sorted { $0 < $1 }
        let grouped = Dictionary(grouping: sorted) { $0 }

        let counted = grouped.map { ($1.count, $0) }
        let max = counted.max(by: { $0.0 < $1.0 })?.0 ?? 0
        let min = counted.min(by: { $0.0 < $1.0 })?.0 ?? 0
        return max - min
    }

    func debugPrint(link: Link<String>) {
        let result = link.toString()
        print(result)
    }

    func createLinks(input: String) -> Link<String> {
        var rootLink: Link<String>?
        var lastLink: Link<String>?
        for value in input {
            let nextLink = Link(value: String(value))
            if rootLink == nil {
                rootLink = nextLink
            }
            if lastLink != nil {
                lastLink?.append(link: nextLink)
            }
            lastLink = nextLink
        }
        return rootLink!
    }

    func process(rules: [Rule], link: Link<String>) {
        var current: Link? = link
        var next: Link? = link.next
        repeat {
            guard let currentValue = current?.value,
                  let nextValue = next?.value else {
                      break
                  }
            let pair = currentValue + nextValue
            if let rule = rules.first(where: { $0.pair == pair}) {
                let link = Link(value: rule.value)

                let nextCurrent = current?.next
                current?.insert(link: link)

                current = nextCurrent
                next = nextCurrent?.next

                continue
            }

            current = link.next
            next = current?.next
        } while (current != nil && next != nil)
    }

    public struct Rule {

        init(input: String) {
            let data = input.components(separatedBy: " -> ")
            pair = data[0]
            value = String(data[1])
        }

        let pair: String
        let value: String
    }

    public class Link<T: Equatable> {

        init(value: T) {
            self.value = value
        }

        let value: T
        var next: Link<T>? = nil

        func append(link: Link) {
            next = link
        }

        func insert(link: Link) {
            if next != nil {
                link.next = next
            }
            next = link
        }

        func find(currentValue: T, nextValue: T) -> Link<T>? {
            if value == currentValue && next?.value == nextValue {
                return self
            }
            return nil
        }

        func toArray() -> [T] {
            var output = [T]()
            self.toArray(&output)
            return output
        }

        private func toArray(_ array: inout [T]) {
            if next != nil {
                next?.toArray(&array)
            }
            array.insert(value, at: 0)
        }
    }
}

extension Day_14.Link where T == String {

    func toString() -> String {
        self.toArray().reduce(into: "", { $0 += $1 })
    }
}
