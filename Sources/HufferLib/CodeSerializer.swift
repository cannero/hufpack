import Foundation

public struct CodeSerializer {
    var ioHandler: IOHandler
    let codes: [Character : String]

    public init(ioHandler: IOHandler, codes: [Character : String]) {
        self.ioHandler = ioHandler
        self.codes = codes
    }

    public func writeHeader(_ content: String) throws {
        try ioHandler.write(contentsOf: Array("HF".utf8))
        // 2 bytes version
        try ioHandler.write(contentsOf: [1,0])

        try writeCodes()

        // 4 bytes content char count
        let charcount = getLengthArray(content.count)
        try ioHandler.write(contentsOf: charcount)
    }

    func writeCodes() throws {
        var codesAsString = ""
        for (char, code) in codes {
            codesAsString += code + ":"
            codesAsString.append(char)
        }

        let codesAsBytes = Array(codesAsString.utf8)

        // 4 bytes for the byte length of the codes
        let length = getLengthArray(codesAsBytes.count)
        try ioHandler.write(contentsOf: length)
        // codes
        try ioHandler.write(contentsOf: codesAsBytes)
    }

    public func writeContent(_ content: String) throws {
        var stringbuffer = ""
        
        for char in content {
            stringbuffer += codes[char]!

            while stringbuffer.count >= 8 {
                let index = stringbuffer.index(stringbuffer.startIndex, offsetBy: 8)
                let nextByte = stringbuffer[..<index]
                let num = convertToUInt8(nextByte)
                try ioHandler.write(contentsOf: num)
                stringbuffer = String(stringbuffer[index...])
            }
        }

        if !stringbuffer.isEmpty {
            let rest = stringbuffer.padding(toLength: 8, withPad: "0", startingAt: 0)
            let num = convertToUInt8(rest)
            try ioHandler.write(contentsOf: num)
        }
    }

    func convertToUInt8<S: StringProtocol>(_ binary: S) -> [UInt8] {
        if let number = UInt8(binary, radix: 2) {
            return [number]
        }

        print("Cannot convert \(binary) to uint8")
        exit(1)
    }

    func getLengthArray(_ length: Int) -> [UInt8] {
        var length = length
        var arr: [UInt8] = []
        while length > 0 {
            arr.append(UInt8(length & 0xff))
            length >>= 8
        }

        while arr.count < 4 {
            arr.append(0)
        }

        arr.reverse()
        return arr
    }
}

enum MySerializerError: Error {
    case conversionFailed
}
