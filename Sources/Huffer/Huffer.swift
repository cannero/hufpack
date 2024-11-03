import ArgumentParser
import Foundation
import HufferLib

@main
struct Huffer: ParsableCommand {
    @Option(help: "Specify the file")
    public var file: String

    mutating func run() throws {
        print(self.file)
        let contents = readFile(filePath: self.file)
        let freqBuilder = FrequencyBuilder()
        let frequencies = freqBuilder.getFrequency(content: contents)
        print(frequencies)
    }

    func readFile(filePath: String) -> String {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            return fileContents
        } catch {
            print("Error reading file: \(error)")
            Huffer.exit(withError: MyError.fileNotFound)
        }
    }
}

enum MyError: Error {
    case fileNotFound
}
