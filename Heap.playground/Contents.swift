import Foundation

enum HeapOrder {
    
}

class Heap<T: Comparable> {
    
    fileprivate var buffer:[T]
    
    init() {
        buffer = [T]()
    }
    
    var count: Int { return buffer.count }
    
    func enque(_ value: T) {
        buffer.append(value)
        
        if buffer.count > 1 {
            var pos: Int? = buffer.count - 1
            while let p = pos, p > 0 {
                pushUp(p)
                pos = parent(p)
            }
        }
    }
    
    func deque() -> T? {
        guard buffer.count > 0 else { return nil }
        let top = buffer.first
        let last = buffer.removeLast()
        if buffer.count > 0 {
            buffer[0] = last
            pushDown(0)
        }
        
        return top
    }

    fileprivate func pushUp(_ pos: Int) {
        guard let parent = parent(pos) else { return }
        if buffer[pos] < buffer[parent] {
            (buffer[pos], buffer[parent]) = (buffer[parent], buffer[pos])
        }
    }

    fileprivate func pushDown(_ pos: Int) {
        if let left = left(pos) {
            var min = left

            if let right = right(pos), buffer[right] < buffer[left] {
                min = right
            }
            
            if buffer[min] < buffer[pos] {
                (buffer[min], buffer[pos]) = (buffer[pos], buffer[min])
                pushDown(min)
            }
        }
    }

    
    fileprivate func parent(_ pos: Int) -> Int? {
        let c = (pos - 1) / 2
        guard c >= 0 else { return nil }
        return c
    }
    
    fileprivate func left(_ pos: Int) -> Int? {
        let c = (pos*2) + 1
        guard c < buffer.count else { return nil }
        return c
    }

    fileprivate func right(_ pos: Int) -> Int? {
        let c = (pos*2) + 2
        guard c < buffer.count else { return nil }
        return c
    }
}


extension Array {
    mutating func randomize() {
        for i in 0..<self.count {
            let r = i + Int(arc4random_uniform(UInt32(self.count - i)))
            (self[i], self[r]) = (self[r], self[i])
        }
    }
}


// TEST
var h = Heap<String>()

var alphabet = (0...25).flatMap{ UnicodeScalar(UnicodeScalar("a").value + $0) }
alphabet.randomize()
for i in alphabet {
    h.enque(String(i))
}

while h.count > 0 {
    print(h.deque()!)
}


