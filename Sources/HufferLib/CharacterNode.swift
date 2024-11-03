struct CharacterNode: Node {
    let weight: Int
    let isLeaf: Bool
    let character: Character
    let left: Node? = nil
    let right: Node? = nil

    init(_ character: Character, _ weight: Int) {
        self.character = character
        self.weight = weight
        self.isLeaf = true
    }
}
