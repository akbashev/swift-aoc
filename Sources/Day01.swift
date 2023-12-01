import Foundation
import RegexBuilder

struct Day01: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: "\n")
  }
  
  static var numbersRegex = Regex {
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
  static var reversedNumbersRegex = Regex {
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
  
  static func convert(_ string: String) -> Int? {
    switch string {
    case "one": 1
    case "two": 2
    case "three": 3
    case "four": 4
    case "five": 5
    case "six": 6
    case "seven": 7
    case "eight": 8
    case "nine": 9
    default: Int(string)
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
        let firstNumber: Int = if let result = next.firstMatch(of: regex) {
          Day01
            .convert(String(result.output)) ?? 0
        } else {
          0
        }
        let secondNumber: Int = if let result = String(next.reversed()).firstMatch(of: reversedRegex) {
          Day01
            .convert(String(result.output.reversed())) ?? 0
          } else {
            0
          }
        let number = firstNumber * 10 + secondNumber
        partial += number
      }
    )
  }
}
