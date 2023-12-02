import Foundation
import RegexBuilder

struct Day02: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: .newlines)
  }
  
  enum Colour: CustomDebugStringConvertible {
    var debugDescription: String {
      switch self {
      case .red: "red"
      case .green: "green"
      case .blue: "blue"
      }
    }
    
    case red
    case green
    case blue
    
    init?(_ rawValue: Substring) {
      switch rawValue {
      case "red": self = .red
      case "blue": self = .blue
      case "green": self = .green
      default: return nil
      }
    }
    
    func isPossible(number: Int) -> Bool {
      return switch self {
      case .red: number <= 12
      case .green: number <= 13
      case .blue: number <= 14
      }
    }
  }

  static var gamesRegex = Regex {
    ChoiceOf {
      Regex {
        "Game "
        Capture {
          OneOrMore(.digit)
        }
      }
      Regex {
        Anchor.wordBoundary
        Capture {
          OneOrMore(.digit)
        }
        OneOrMore(.whitespace)
        Capture {
          ChoiceOf {
            "red"
            "blue"
            "green"
          }
        }
        Anchor.wordBoundary
      }
    }
  }
  .anchorsMatchLineEndings()

  typealias Index = Int
  func part1() -> Any {
    let regex = Day02.gamesRegex
    return entities
      .compactMap { line -> (index: Index, isPossible: Bool)? in
        guard
          let index = line.firstMatch(of: regex)?.1.flatMap({ Int($0) })
        else { return .none }
        let impossibles = line
          .matches(of: regex)
          .compactMap { pattern -> (Int, Colour)? in
            guard
              let number = pattern.2.flatMap({ Int($0) }),
              let colour = pattern.3.flatMap({ Colour($0) }),
              !colour.isPossible(number: number)
            else { return .none }
            return (number, colour)
          }
        return (index: index, isPossible: impossibles.isEmpty)
      }
      .filter { $0.isPossible }
      .reduce(into: 0, { (partial, next) in
        partial += next.index
      }
    )
  }
  
  func part2() -> Any {
    let regex = Day02.gamesRegex
    return entities
      .compactMap { line -> (index: Index, power: Int)? in
        guard
          let index = line.firstMatch(of: regex)?.1.flatMap({ Int($0) })
        else { return .none }
        let variants = line
          .matches(of: regex)
          .reduce(
            into: [Colour:Int](),
            { (partial, pattern) in
              guard
                let number = pattern.2.flatMap({ Int($0) }),
                let colour = pattern.3.flatMap({ Colour($0) })
              else { return }
              partial[colour, default: 0] = max(partial[colour, default: 0], number)
            }
          )
        let power: Int = variants[.red, default: 1] * variants[.green, default: 1] * variants[.blue, default: 1]
        return (index: index, power: power)
      }
      .reduce(into: 0, { (partial, next) in
        partial += next.power
      }
    )
  }
}
