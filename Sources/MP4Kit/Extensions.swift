//
//  Extensions.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//
import Foundation

// MARK: - Array<UInt8>
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

// MARK: - String
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

// MARK: - Array
extension Array {
    func slice(_ length: Int) -> [[Element]] {
        var result = [[Element]]()
        var tmp = [Element]()
        for (i, c) in self.enumerated() {
            tmp.append(c)
            if tmp.count == length {
                result.append(tmp)
                tmp.removeAll()
            }
            else if i == self.count - 1, tmp.count > 0 {
                result.append(tmp)
            }
        }
        return result
    }
}

// MARK: - Double
extension Double {
    func double1616ToUInt32() -> UInt32 {
        return UInt32(self * Double(1 << 16))
    }
    func double0230ToUInt32() -> UInt32 {
        return UInt32(self * Double(1 << 30))
    }
}

// MARK: - Float
extension Float {
    func float88ToUInt32() -> UInt32 {
        return UInt32(self * Float(1 << 8))
    }
}

// MARK: - Date
extension Date {
    init(sinceReferenceDate n: UInt64) {
        self = Date(
            timeInterval: TimeInterval(n),
            since: Constants.referenceDate
        )
    }
    // swiftlint:disable:next function_parameter_count
    static func utc
        (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int)
        -> Date {
        let cal = Calendar(identifier: .gregorian)
        let c = DateComponents(calendar: cal,
            timeZone: TimeZone(abbreviation: "UTC"),
            year: year, month: month, day: day, hour: hour, minute: minute, second: second
        )
        return c.date!
    }
}

// MARK: Date
extension Date {
    public var uint64Value: UInt64 {
        return UInt64(self.timeIntervalSince(Constants.referenceDate))
    }
    public var uint32Value: UInt32 {
        return UInt32(self.timeIntervalSince(Constants.referenceDate))
    }
}

// MARK: - BitStreamEncodable
// MARK: UInt16
extension UInt16: BitStreamEncodable {
    public func encode() throws -> [UInt8] {
        return toByteArray(self).reversed()
    }
}

// MARK: UInt32
extension UInt32: BitStreamEncodable {
    public func encode() throws -> [UInt8] {
        return toByteArray(self).reversed()
    }
}

// MARK: UInt64
extension UInt64: BitStreamEncodable {
    public func encode() throws -> [UInt8] {
        return toByteArray(self).reversed()
    }
}

// MARK: String
extension String: BitStreamEncodable {
    public func encode() throws -> [UInt8] {
        guard self.characters.count == 4 else {
            return [0, 0, 0, 0]
        }
        return self.utf8.map{UInt8($0)}
    }
}

func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafeBytes(of: &value) { Array($0) }
}

// MARK: BitSet
extension BitSet: BitStreamEncodable {
    public func encode() throws -> [UInt8] {
        let arr: [[Bool]] = (0..<size).map{self[$0]}.slice(8)
        var result: [UInt8] = []
        for bit8Arr in arr {
            var byte: Int = 0
            byte += bit8Arr[0] ? 1 << 7 : 0
            byte += bit8Arr[1] ? 1 << 6 : 0
            byte += bit8Arr[2] ? 1 << 5 : 0
            byte += bit8Arr[3] ? 1 << 4 : 0
            byte += bit8Arr[4] ? 1 << 3 : 0
            byte += bit8Arr[5] ? 1 << 2 : 0
            byte += bit8Arr[6] ? 1 << 1 : 0
            byte += bit8Arr[7] ? 1 : 0
            result.append(UInt8(byte))
        }
        return result
    }
}

// MARK: - BitSet
extension BitSet {
    init(bytes: [UInt8]) {
        self.init(size: bytes.count * 8)
        for (index, byte) in bytes.enumerated() {
            self[index*8+0] = (byte & 1 << 7) == 1 << 7
            self[index*8+1] = (byte & 1 << 6) == 1 << 6
            self[index*8+2] = (byte & 1 << 5) == 1 << 5
            self[index*8+3] = (byte & 1 << 4) == 1 << 4
            self[index*8+4] = (byte & 1 << 3) == 1 << 3
            self[index*8+5] = (byte & 1 << 2) == 1 << 2
            self[index*8+6] = (byte & 1 << 1) == 1 << 1
            self[index*8+7] = (byte & 1) == 1
        }
    }
}
