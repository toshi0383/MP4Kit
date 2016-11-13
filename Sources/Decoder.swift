//
//  Decoder.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public func decodeBox<T: BitStreamDecodable>(_ data: Data) throws -> T {
    return try T.decode(data)
}

func decodeBoxHeader(_ data: Data) -> (UInt32, BoxType)? {
    let size = data[0..<4].map{$0}.uint32Value
    guard let boxtype: String = try? extract(data[4..<8].map{$0}) else {
        print("[decodeBoxHeader] extract was nil")
        return nil
    }
    guard let type = BoxType(rawValue: boxtype) else {
        print("[decodeBoxHeader] BoxType.init was nil")
        return nil
    }
    return (size, type)
}

func extract(_ data: Data) throws -> UInt32 {
    return data.withUnsafeBytes{$0.pointee}
}

func extract(_ bytes: [UInt8]) throws -> String {
    return try extract(Data(bytes: bytes))
}

func extract(_ data: Data) throws -> String {
    guard let str = String(data: data, encoding: String.Encoding.utf8) else {
        throw BitStreamDecodeError.TypeMismatch
    }
    return str
}
