//
//  AHeap.swift
//  RimWorld
//
//  Created by wu on 2025/6/6.
//

import Foundation

/// 泛型最小/最大堆实现（根据 areSorted 规则决定排序方向）
class AHeap<T> {
    
    /// 存储堆中所有元素的数组
    var elements: [T] = []
    
    /// 比较函数，用于确定堆是最大堆还是最小堆
    /// - 如果是 A* 算法，通常使用 `node1.fCost < node2.fCost`
    let areSorted: (T, T) -> Bool
    
    /// 初始化堆，传入比较函数
    init(sort: @escaping (T, T) -> Bool) {
        self.areSorted = sort
    }
    
    /// 堆是否为空
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    /// 向堆中插入一个元素
    func insert(_ value: T) {
        elements.append(value)
        siftUp(from: elements.count - 1) // 插入后向上调整保持堆结构
    }
    
    /// 弹出堆顶元素（即最小值或最大值，取决于排序规则）
    func remove() -> T? {
        guard !isEmpty else { return nil }
        elements.swapAt(0, elements.count - 1) // 将最后一个元素移到堆顶
        let item = elements.removeLast()       // 删除原堆顶元素
        siftDown(from: 0)                      // 从堆顶向下调整
        return item
    }
    
    /// 在堆中查找第一个匹配给定条件的元素（非必要，仅辅助功能）
    func first(where predicate: (T) -> Bool) -> T? {
        return elements.first(where: predicate)
    }
    
    /// 向上调整：用于插入元素后维持堆的有序结构
    private func siftUp(from index: Int) {
        var child = index
        var parent = (child - 1) / 2
        while child > 0 && areSorted(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = (child - 1) / 2
        }
    }
    
    /// 向下调整：用于移除堆顶元素后维持堆的有序结构
    private func siftDown(from index: Int) {
        var parent = index
        while true {
            let left = parent * 2 + 1  // 左子节点
            let right = parent * 2 + 2 // 右子节点
            var candidate = parent    // 记录当前最合适的节点
            
            // 如果左子节点存在并且更小/更大（根据比较函数），更新 candidate
            if left < elements.count && areSorted(elements[left], elements[candidate]) {
                candidate = left
            }
            // 如果右子节点更合适，继续更新
            if right < elements.count && areSorted(elements[right], elements[candidate]) {
                candidate = right
            }
            
            // 如果没有更小/更大的子节点，说明已完成
            if candidate == parent { return }
            
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

