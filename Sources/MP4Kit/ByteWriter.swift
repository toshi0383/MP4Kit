//
//  ByteWriter.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/25.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

class ByteWriter {
    private var fp: UnsafeMutablePointer<FILE>
    private let path: String
    init(path: String) {
        self.path = path
        self.fp = fopen(path, "w")
    }
    func write(_ bytes: [UInt8]) {
        fwrite(bytes, 1, bytes.count, fp)
    }
    func close() {
        fclose(fp)
    }
}
