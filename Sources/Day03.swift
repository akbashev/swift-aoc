import Foundation
import RegexBuilder


struct Day03: AdventDay {
  var data: String
  
  var entities: [String] {
    data
      .components(separatedBy: .newlines)
      .filter { $0 != "" }
      .reduce(
        into: [String](),
        { $0.append($1) }
      )
  }
  
  static var numbersRegex = Regex {
    OneOrMore(.digit)
  }
  
  func part1() -> Any {
    let entities = self.entities
    let numbersRegex = Day03.numbersRegex
    return entities
      .enumerated()
      .reduce(
        into: [Int](),
        { (partial, next) in
          let (index, line) = next
          for number in line.matches(of: numbersRegex) {
            guard let value = Int(number.0) else { continue }
            let start = {
              if line.distance(from: line.startIndex, to: number.startIndex) == 0 {
                return number.startIndex
              }
              return line.index(number.startIndex, offsetBy: -1)
            }()
            let end = {
              if line.distance(from: line.startIndex, to: number.endIndex) == line.count {
                return number.endIndex
              }
              return line.index(number.endIndex, offsetBy: +1)
            }()
            let range = start..<end
            let previous = {
              if index > 0 {
                return Day03.containsSpecialSymbol(entities[index - 1][range])
              }
              return false
            }()
            let current = Day03.containsSpecialSymbol(entities[index][range])
            let next = {
              if index < entities.count - 1 {
                return Day03.containsSpecialSymbol(entities[index + 1][range])
              }
              return false
            }()
            
            if (previous || current || next) {
              partial.append(value)
            }
          }
        }
      ).reduce(0, +)
  }
  
  static func containsSpecialSymbol(
    _ line: Substring
  ) -> Bool {
    !line
      .filter { ($0.isWholeNumber || $0 == ".") == false }
      .isEmpty
  }
}