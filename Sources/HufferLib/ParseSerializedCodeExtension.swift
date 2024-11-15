import Foundation

// https://www.swiftbysundell.com/articles/string-parsing-in-swift/
extension String {

    enum ParseState {
        case code
        case key
    }

    var codes: [String : Character] {
        var currentState: ParseState = .code
        var partialCode: String?
        var parsed: [String : Character] = [:]

        func parse(_ character: Character) {
            switch currentState {
            case .code:
                if character == ":" {
                    currentState = .key
                } else {
                    if var currentCode = partialCode {
                        currentCode.append(character)
                        partialCode = currentCode
                    } else {
                        partialCode = String(character)
                    }
                }
            case .key:
                parsed[partialCode!] = character
                currentState = .code
                partialCode = nil
            }
        }

        forEach(parse)

        return parsed
    }
}
