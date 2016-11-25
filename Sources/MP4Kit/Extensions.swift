//
//  Extensions.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//
import Foundation

protocol _UInt8 {}
extension UInt8: _UInt8 {}
extension Array where Element: _UInt8 {
    var uint64Value: UInt64 {
        let bigEndianValue = self.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt64.self, capacity: 1) { $0 })
            }.pointee
        return UInt64(bigEndian: bigEndianValue)
    }
    var uint32Value: UInt32 {
        let bigEndianValue = self.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
            }.pointee
        return UInt32(bigEndian: bigEndianValue)
    }
    var uint16Value: UInt16 {
        let bigEndianValue = self.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
            }.pointee
        return UInt16(bigEndian: bigEndianValue)
    }
    var float88Value: Float {
        return Float(self.uint16Value) / Float(1 << 8)
    }
    var double1616Value: Double {
        return Double(self.uint32Value) / Double(1 << 16)
    }
    var double0230Value: Double {
        return Double(self.uint32Value / 1 << 30)
    }
    func stringValue() throws -> String {
        let a = self.flatMap{$0 as? UInt8}
        guard let str = String(bytes: a, encoding: String.Encoding.utf8) else {
            throw Error(problem: "Failed to parse String from: \(self)")
        }
        return str
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

extension Date {
    init(sinceReferenceDate n: UInt64) {
        self = Date(
            timeInterval: TimeInterval(n),
            since: Constants.referenceDate
        )
    }
}
