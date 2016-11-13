//
//  Extensions.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

extension Array {
    var uint32Value: UInt32 {
        let bigEndianValue = self.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
            }.pointee
        return UInt32(bigEndian: bigEndianValue)
    }
}

extension String {
    func slice(_ length: Int) -> [String] {
        guard self.characters.count >= length else {
            return []
        }
        var arr = [String]()
        var cArr = [Character]()
        for (i, c) in characters.enumerated() {
            cArr.append(c)
            if cArr.count == length {
                arr.append(String(cArr))
                cArr.removeAll()
            }
            if i == characters.count - 1, cArr.count > 0 {
                arr.append(String(cArr))
            }
        }
        return arr
    }
}
