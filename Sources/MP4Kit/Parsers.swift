//
//  Parsers.swift
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
    public func parse(shouldSkipPayload: ((BoxType) -> Bool)? = nil) throws -> MP4 {
        var boxes: [IntermediateBox] = []
        while reader.hasNext() {
            do {
                // Store bytes on IntermediateBox, not parsed yet.
                // IntermediateBox knows only size(UInt64) and type(BoxType).
                boxes.append(try IntermediateBox(bytes: try reader.nextBox(shouldSkipPayload)))
            } catch {
                print("\(error)")
                continue
            }
        }
        return MP4(
            container: ISO14496Part12Container(
                // Here <- and <-? operators finally does parsing.
                ftyp: try boxes <- FileTypeBox.self,
                moov: try boxes <- MovieBox.self,
                mdat: try boxes <-? MediaDataBox.self
            )
        )
    }
}
