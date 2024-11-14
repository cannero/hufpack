import Testing
@testable import HufferLib

struct SerializedCodeParserTests {

    @Test func codesExtensionSingleCode() {
        let input = "a1;"
        let expectedOutput = [Character("a"): "1"]
        #expect(input.codes == expectedOutput)
    }

    @Test func codesExtensionMultipleUtf8Chars() {
        let input = "😎1010;🌯10001;ü001;"
        let expectedOutput: [Character : String] = ["😎" : "1010", "🌯" : "10001", "ü" : "001"]
        #expect(input.codes == expectedOutput)
    }
}
