struct TestHelper {
    public static func getTwoFrequencies() -> [Character : Int] {
        [Character("a"): 4, Character("b"): 2]
    }

    public static func getThreeFrequencies() -> [Character : Int] {
        var d = [Character("c"): 1]
        d.merge(getTwoFrequencies()) { (current, _) in current }
        return d
    }
}
