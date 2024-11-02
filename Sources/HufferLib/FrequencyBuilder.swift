public struct FrequencyBuilder {
    public init(){}
    
    public func getFrequency(content: String) -> [Character : Int] {
        var frequencies: [Character : Int] = [:]
        for char in content {
            if let count = frequencies[char] {
                frequencies[char] = count + 1
            } else {
                frequencies[char] = 1
            }
        }
        return frequencies
    }
}
