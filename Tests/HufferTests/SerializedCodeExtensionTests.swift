import Testing
@testable import HufferLib

struct SerializedCodeParserTests {

    @Test func codesExtensionSingleCode() {
        let input = "1:a"
        let expectedOutput = ["1" : Character("a") ]
        #expect(input.codes == expectedOutput)
    }

    @Test func codesExtensionMultipleUtf8Chars() {
        let input = "1010:😎10001:🌯001:ü;"
        let expectedOutput: [String : Character] = ["1010" : "😎", "10001" : "🌯", "001" : "ü"]
        #expect(input.codes == expectedOutput)
    }
}
