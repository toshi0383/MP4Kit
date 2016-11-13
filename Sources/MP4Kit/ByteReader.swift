//
//  ByteReader.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

internal struct Constants {
    static let bufferSize: Int = 36
}

class ByteReader {
    private let fp: UnsafeMutablePointer<FILE>
    init(path: String) {
        self.fp = fopen(path, "rb")
    }
    func next(size: Int) -> [UInt8]? {
        var buf = Array<UInt8>(repeating: 0, count: size)
        fread(&buf, 1, size, fp)
        return buf
    }
    func data(size: Int) -> Data? {
        if let bytes = next(size: size) {
            return Data(bytes: bytes)
        } else {
            return nil
        }
    }
    func hasNext() -> Bool {
        return feof(fp) == 0
    }
    func seek(_ amount: Int) {
        fseek(fp, amount, SEEK_CUR)
    }
    deinit {
        fclose(fp)
    }
}