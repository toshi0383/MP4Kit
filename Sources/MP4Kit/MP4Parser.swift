//
//  MP4Builder.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/14.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

/// Parse MP4 File at path
public class MonolithicMP4FileParser {
    private let reader: ByteReader
    public init(path: String) {
        self.reader = ByteReader(path: path)
    }
    public func parse() throws -> MP4 {
        var boxes: [Box] = []
        while reader.hasNext() {
            guard let data: Data = reader.data(size: Constants.bufferSize) else {
                continue
            }
            guard let (size, boxtype) = decodeBoxHeader(data) else {
                continue
            }

            switch boxtype {
            case .ftyp:
                let ftyp: FileTypeBox = try decodeBox(data[0..<Int(size)].map{$0})
                boxes.append(ftyp)
            }
            reader.seek(-Constants.bufferSize + Int(size))
        }
        return MP4(
            container: ISO14496Part12Container(
                ftyp: boxes.flatMap{$0 as? FileTypeBox}[0]
            )
        )
    }
}
