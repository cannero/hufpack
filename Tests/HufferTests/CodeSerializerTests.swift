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

    @Test func getCodeWith16Bits() throws {
        let (handler, serializer) = createTestingClasses(codes)
        let expectedOutput: [UInt8] = [ 0b11000011, 0b00111100]
        try serializer.writeContent("abba")

        #expect(handler.buffer == expectedOutput)
    }

    @Test func getCodeWith12Bits_LastByteFilledUpWithZeros() throws {
        let (handler, serializer) = createTestingClasses(codes)
        let expectedOutput: [UInt8] = [ 0b11000011, 0b00110000]
        try serializer.writeContent("abb")

        #expect(handler.buffer == expectedOutput)
    }

    // this code doesn't make a lot of sense, just for edge case test
    @Test func getCodeWithMoreThan8Bits() throws {
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
