//
//  ByteReader.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

class ByteReader {
    struct Constants {
        static let bufferSize: Int = 36
    }

    private let fp: UnsafeMutablePointer<FILE>
    init(path: String) {
        self.fp = fopen(path, "rb")
    }
    @discardableResult
    func next(size: Int) -> [UInt8] {
        var buf = Array<UInt8>(repeating: 0, count: size)
        fread(&buf, 1, size, fp)
        return buf
    }
    func data(size: Int) -> Data {
        return Data(bytes: next(size: size))
    }
    func hasNext() -> Bool {
        return feof(fp) == 0
    }
    func rewind() {
        fseek(fp, 0, SEEK_SET)
    }
    func seek(_ amount: Int) {
        fseek(fp, amount, SEEK_CUR)
    }
    deinit {
        fclose(fp)
    }
}

extension ByteReader {
    func nextBox(shouldSkipPayload: ((BoxType) -> Bool)? = nil) throws -> [UInt8] {
        let bytes = next(size: Constants.bufferSize)
        let size = bytes[0..<4].map{$0}.uint32Value
        let boxtypeStr = try bytes[4..<8].map{$0}.stringValue()
        guard let boxtype = BoxType(rawValue: boxtypeStr) else {
            seek(-Constants.bufferSize+Int(size)-1)
            next(size: 1) // fseek does not make feof check enabled.
            throw Error(problem: "Failed to detect Box Type from: \(boxtypeStr)")
        }
        if let f = shouldSkipPayload {
            if f(boxtype) {
                seek(-Constants.bufferSize+Int(size)) // skip data part
                return bytes
            }
        }

        let boxbytes: [UInt8]
        if bytes.endIndex < Int(size) {
            seek(-bytes.endIndex)
            boxbytes = next(size: Int(size))
        } else {
            seek(-Constants.bufferSize+Int(size))
            boxbytes = bytes
        }
        return boxbytes
    }
}
