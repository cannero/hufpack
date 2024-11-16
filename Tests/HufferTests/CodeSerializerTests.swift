import Foundation
import Testing
@testable import HufferLib

struct CodeSerializerTests {
    let codes: [Character : String] = ["a": "1100", "b": "0011"]

    func createTestingClasses(_ codesToUse: [Character : String]) -> (IOHandlerMock, CodeSerializer) {
        let handler = IOHandlerMock()
        let serializer = CodeSerializer(ioHandler: handler, codes: codesToUse)
        return (handler, serializer)
    }

    @Test func writeHeader() throws {
        let (handler, serializer) = createTestingClasses(codes)
        let expectedOutput_a: [UInt8] = [
            // HF and version 1.0
            0x48, 0x46, 0x01, 0x00,
            // length codes
            0x00, 0x00, 0x00, 0x0c,
            // codes, a is written first
            0x31, 0x31, 0x30, 0x30, 0x3a, 0x61,
            0x30, 0x30, 0x31, 0x31, 0x3a, 0x62,
            // char count
            0x00, 0x00, 0x00, 0x02,
        ]

        let expectedOutput_b: [UInt8] = [
            // HF and version 1.0
            0x48, 0x46, 0x01, 0x00,
            // length codes
            0x00, 0x00, 0x00, 0x0c,
            // codes, b is written first
            0x30, 0x30, 0x31, 0x31, 0x3a, 0x62,
            0x31, 0x31, 0x30, 0x30, 0x3a, 0x61,
            // char count
            0x00, 0x00, 0x00, 0x02,
        ]

        try serializer.writeHeader("😈😻")

        #expect(handler.buffer == expectedOutput_a || handler.buffer == expectedOutput_b)
    }

    @Test func writeCodesWithUtf8Chars() throws {
        let utf8Code: [Character : String] = ["🤠": "1"]
        let (handler, serializer) = createTestingClasses(utf8Code)
        let expectedOutput: [UInt8] = [
            // length codes
            0x00, 0x00, 0x00, 0x06,
            0x31, 0x3a, 0xf0, 0x9f, 0xa4, 0xa0]
        try serializer.writeCodes()

        #expect(handler.buffer == expectedOutput)
    }

    @Test func writeCodesWithNewline() throws {
        let newlineCode: [Character : String] = ["\r\n": "0"]
        let (handler, serializer) = createTestingClasses(newlineCode)
        let expectedOutput: [UInt8] = [
            // length codes
            0x00, 0x00, 0x00, 0x04,
            0x30, 0x3a, 0x0d, 0x0a]
        try serializer.writeCodes()

        #expect(handler.buffer == expectedOutput)
    }

    @Test func writeContentWith16Bits() throws {
        let (handler, serializer) = createTestingClasses(codes)
        let expectedOutput: [UInt8] = [ 0b11000011, 0b00111100]
        try serializer.writeContent("abba")

        #expect(handler.buffer == expectedOutput)
    }

    @Test func writeContentWith12Bits_LastByteFilledUpWithZeros() throws {
        let (handler, serializer) = createTestingClasses(codes)
        let expectedOutput: [UInt8] = [ 0b11000011, 0b00110000]
        try serializer.writeContent("abb")

        #expect(handler.buffer == expectedOutput)
    }

    // this code doesn't make a lot of sense, just for edge case test
    @Test func writeContentWithMoreThan8Bits() throws {
        let longCodes: [Character : String] = ["a": "1111111111111111", "b": "0000000000001111"]
        let (handler, serializer) = createTestingClasses(longCodes)
        let expectedOutput: [UInt8] = [ 0b1111_1111, 0b1111_1111, 0b0000_0000, 0b0000_1111]
        try serializer.writeContent("ab")

        #expect(handler.buffer == expectedOutput)
    }

}

class IOHandlerMock : IOHandler {
    var buffer: [UInt8] = []

    init() {
    }

     func write<T>(contentsOf data: T) throws where T : DataProtocol {
        buffer.append(contentsOf: data as! [UInt8])
    }
}
