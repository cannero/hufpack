import Collections

public struct TreeBuilder {

    internal func buildTree(frequencies: [Character : Int]) -> HuffTree {
        var heap = createHeap(frequencies)
        let tree = mergeNodes(&heap)
        return tree
    }

    internal func createHeap(_ frequencies: [Character : Int]) -> Heap<HuffTree> {
        var heap: Heap<HuffTree> = []
        for (char, weight) in frequencies {
            heap.insert(HuffTree(char, weight))
        }

        return heap
    }

    internal func mergeNodes(_ heap: inout Heap<HuffTree>) -> HuffTree {
        while heap.count > 1 {
            let tree1 = heap.removeMin()
            let tree2 = heap.removeMin()
            let treeResult = HuffTree(left: tree1.root, right: tree2.root)
            heap.insert(treeResult)
        }

        return heap.removeMin()
    }
}
