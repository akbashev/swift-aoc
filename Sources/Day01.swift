import Foundation
import RegexBuilder

struct Day01: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: "\n")
  }
  
  static var numbersRegex = Regex<Substring> {
    ChoiceOf {
      "one"
      "two"
      "three"
      "four"
      "five"
      "six"
      "seven"
      "eight"
      "nine"
      One(.digit)
    }
  }.anchorsMatchLineEndings()
  
  /// No lookbehind currently in Swift, so a hack
  static var reversedNumbersRegex = Regex<Substring> {
    ChoiceOf {
      "eno"
      "owt"
      "eerht"
      "ruof"
      "evif"
      "xis"
      "neves"
      "thgie"
      "enin"
      One(.digit)
    }
  }.anchorsMatchLineEndings()
  
  static func convert(_ c: Substring) -> Int? {
    switch c {
    case "one", "eno": 1
    case "two", "owt": 2
    case "three", "eerht": 3
    case "four", "ruof": 4
    case "five", "evif": 5
    case "six", "xis": 6
    case "seven", "neves": 7
    case "eight", "thgie": 8
    case "nine", "enin": 9
    default: c.first?.wholeNumberValue
    }
  }

  func part1() -> Any {
    entities.reduce(
      into: 0,
      { (partial, next) in
        let numbers = next
          .compactMap { $0.wholeNumberValue }
        let number = (numbers.first ?? 0) * 10 + (numbers.last ?? 0)
        partial += number
      }
    )
  }
  
  func part2() -> Any {
    let regex = Day01.numbersRegex
    let reversedRegex = Day01.reversedNumbersRegex
    return entities.reduce(
      into: 0,
      { (partial, next) in
        let firstNumber: Int = next.firstMatch(of: regex).flatMap { Day01.convert($0.output) } ?? 0
        let secondNumber: Int = String(next.reversed()).firstMatch(of: reversedRegex).flatMap { Day01.convert($0.output) } ?? 0
        let number = firstNumber * 10 + secondNumber
        partial += number
      }
    )
  }
}
