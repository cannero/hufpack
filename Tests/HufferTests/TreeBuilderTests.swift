import Testing
import Collections
@testable import HufferLib

struct TreeBuilderTests {
    var treebuilder: TreeBuilder

    init() {
        treebuilder = TreeBuilder()
    }

    func getSingleFrequency() -> [Character : Int] {
        [Character("a"): 1]
    }

    func getTwoFrequencies() -> [Character : Int] {
        [Character("a"): 4, Character("b"): 2]
    }

    func getThreeFrequencies() -> [Character : Int] {
        var d = [Character("c"): 1]
        d.merge(getTwoFrequencies()) { (current, _) in current }
        return d
    }

    @Test func getFrequencyWithSingleCharacter() {
        let expectedOutput = HuffTree("a", 1)
        #expect(treebuilder.buildTree(frequencies: getSingleFrequency()) == expectedOutput)
    }

    @Test func createHeapReturnsInitialHeap() {
        let expectedOutput = HuffTree("b", 2)
        var heap = treebuilder.createHeap(getTwoFrequencies())
        #expect(heap.popMin() == expectedOutput)
    }

    @Test func buildTreeReturnsCorrectTree() {
        let nodeA = CharacterNode("a", 4)
        let nodeB = CharacterNode("b", 2)
        let nodeC = CharacterNode("c", 1)
        let nodeBAndC = InternalNode(left: nodeC, right: nodeB)
        let expectedOutput = HuffTree(left: nodeBAndC, right: nodeA)
        let tree = treebuilder.buildTree(frequencies: getThreeFrequencies())
        #expect(tree == expectedOutput)
        let root = tree.root as! InternalNode
        #expect((root.left as! InternalNode).isLeaf  == false)
        #expect((root.right as! CharacterNode).character == nodeA.character)
    }
}
