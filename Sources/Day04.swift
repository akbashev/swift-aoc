import Foundation

struct Day04: AdventDay {
  var data: String

  var entities: [String] {
    data
      .components(separatedBy: .newlines)
      .filter { $0 != "" }
  }
  static var gamesRegex = /:((?:\s+\d+)*) \|((?:\s+\d+)*)/
  static var numbersRegex = /\d+/

  func part1() -> Any {
    entities
      .reduce(
        into: [Int]()
      ) { partialResult, line in
        var numbers: [Int] = []
        for match in line.matches(of: Day04.gamesRegex) {
          let firstNumbers = match.1.matches(of: Day04.numbersRegex).compactMap { Int($0.0) }
          let secondNumbers = match.2.matches(of: Day04.numbersRegex).compactMap { Int($0.0) }
          numbers = firstNumbers.filter(secondNumbers.contains)
        }
        let number = numbers.enumerated()
          .reduce(
            into: 0, { (partial, _) in
              if partial == 0 {
                partial += 1
              } else {
                partial = partial * 2
              }
            })
        partialResult.append(number)
      }
      .reduce(0, +)
  }
  
  func part2() -> Any {
    entities
      .enumerated()
      .reduce(
        into: [Int: Int]()
      ) { partialResult, next in
        let (index, line) = next
        var numbers: [Int] = []
        for match in line.matches(of: Day04.gamesRegex) {
          let firstNumbers = match.1.matches(of: Day04.numbersRegex).compactMap { Int($0.0) }
          let secondNumbers = match.2.matches(of: Day04.numbersRegex).compactMap { Int($0.0) }
          numbers = firstNumbers.filter(secondNumbers.contains)
        }
        partialResult[index, default: 0] += 1
        for i in 0..<numbers.count {
          partialResult[index + i + 1, default: 0] += partialResult[index] ?? 1
        }
      }
      .reduce(into: 0, { $0 += $1.value })
  }
}
