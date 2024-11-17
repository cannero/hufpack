import Foundation

public struct CodeDeserializer {

    public init(){}

    public func deserialize<S: AsyncSequence>(_ sequence: S) async throws -> String where S.Element == UInt8 {
        var iterator = sequence.makeAsyncIterator()
        let idAndVersion = try await iterator.next(4)

        if idAndVersion != [0x48, 0x46, 0x01, 0x00] {
            print("id or version wrong")
            exit(4)
        }

        let lengthCodesHex = try await iterator.next(4)
        let lengthCodes = bytesToNum(lengthCodesHex)

        let codesHex = try await iterator.next(lengthCodes)
        let codesMaybe = String(data: Data.init(codesHex), encoding: .utf8)

        guard let codesString = codesMaybe else {
            print("could not parse to utf8")
            print(codesHex)
            exit(3)
        }

        let codes = codesString.codes

        let countHuffHex = try await iterator.next(4)
        let countHuffBlock = bytesToNum(countHuffHex)
        let result = try await parseHuffmanCodes(codes, countHuffBlock, &iterator)

        if result.count < countHuffBlock {
            print(result)
            print("length don't match \(result.count) <-> \(countHuffBlock)")
            exit(5)
        }

        return result
    }

    func bytesToNum(_ bytes: [UInt8]) -> Int {
        guard bytes.count == 4 else {
            print("input must be 4 bytes")
            exit(2)
        }

        var num = 0
        for b in bytes {
            num <<= 8
            num |= Int(b)
        }

        return num
    }

    func parseHuffmanCodes<I: AsyncIteratorProtocol>(_ codes: [String : Character], _ charCount: Int, _ bytes: inout I) async throws
    -> String  where I.Element == UInt8 {
        var result = ""
        var currentBuffer = ""

        while let byte = try await bytes.next() {
            for bit in toBits(byte) {
                if bit {
                    currentBuffer.append("1")
                } else {
                    currentBuffer.append("0")
                }
                if let char = codes[currentBuffer] {
                    result.append(char)
                    if result.count == charCount {
                        break
                    }

                    currentBuffer = ""
                }
            }
        }

        return result
    }

    func toBits(_ byte: UInt8) -> [Bool] {
        var byte = byte
        var res: [Bool] = []
        for _ in 0..<8 {
            if byte & 0x80 != 0 {
                res.append(true)
            } else {
                res.append(false)
            }

            byte <<= 1
        }

        return res
    }
}

extension AsyncIteratorProtocol where Element == UInt8{
    mutating func next(_ count: Int) async throws -> [UInt8] {
        var result: [UInt8] = []
        for _ in 0..<count {
            guard let element = try await next() else { break }
            result.append(element)
        }
        return result
    }
}
