struct HuffTree {
    let root: Node
    let weight: Int

    init(_ character: Character, _ weight: Int) {
        root = CharacterNode(character, weight)
        self.weight = weight
    }

    init(left: Node, right: Node) {
        root = InternalNode(left: left, right: right)
        weight = root.weight
    }
}

extension HuffTree: Comparable {
    static func < (lhs: HuffTree, rhs: HuffTree) -> Bool {
        lhs.weight < rhs.weight
    }

    static func == (lhs: HuffTree, rhs: HuffTree) -> Bool {
        lhs.weight == rhs.weight
    }
}
