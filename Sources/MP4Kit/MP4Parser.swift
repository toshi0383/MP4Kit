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
            let data: Data = reader.data(size: Constants.bufferSize)
            guard let (size, boxtypeOptional) = try? decodeBoxHeader(data) else {
                continue
            }
            guard let boxtype = boxtypeOptional else {
                reader.seek(-Constants.bufferSize+Int(size)-1)
                reader.next(size: 1) // fseek does not make feof check enabled.
                continue
            }

            let boxdata: Data
            if data.endIndex < Int(size) {
                reader.seek(-data.endIndex)
                boxdata = reader.data(size: Int(size))
            } else {
                reader.seek(-Constants.bufferSize+Int(size))
                boxdata = data
            }

            switch boxtype {
            case .ftyp where !boxes.contains{$0 is FileTypeBox}:
                let ftyp: FileTypeBox = try decodeBox(boxdata[0..<Int(size)].map{$0})
                boxes.append(ftyp)
            case .moov where !boxes.contains{$0 is MovieBox}:
                let moov: MovieBox = try decodeBox(boxdata[0..<Int(size)].map{$0})
                boxes.append(moov)
            default:
                break
            }
        }
        return MP4(
            container: ISO14496Part12Container(
                ftyp: boxes.flatMap{$0 as? FileTypeBox}[0],
                moov: boxes.flatMap{$0 as? MovieBox}[0]
            )
        )
    }
}
