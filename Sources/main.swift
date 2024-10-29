import ArgumentParser

@main
struct huffer: ParsableCommand {
  @Option(help: "Specify the input")
  public var input: String

    public func run() throws {
        print(self.input)
  }
}
