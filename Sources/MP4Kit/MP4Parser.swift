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
            let bytes = reader.next(size: Constants.bufferSize)
            guard let (size, boxtypeOptional) = try? decodeBoxHeader(bytes) else {
                continue
            }
            guard let boxtype = boxtypeOptional else {
                reader.seek(-Constants.bufferSize+Int(size)-1)
                reader.next(size: 1) // fseek does not make feof check enabled.
                continue
            }
            if boxtype == .mdat {
                reader.seek(-Constants.bufferSize)
                let buf = ByteBuffer(bytes: bytes)
                boxes.append(try MediaDataBox(buf))
                reader.seek(-Constants.bufferSize+Int(size)) // skip data part
                continue
            }

            let boxbytes: [UInt8]
            if bytes.endIndex < Int(size) {
                reader.seek(-bytes.endIndex)
                boxbytes = reader.next(size: Int(size))
            } else {
                reader.seek(-Constants.bufferSize+Int(size))
                boxbytes = bytes
            }

            switch boxtype {
            case .ftyp where !boxes.contains{$0 is FileTypeBox}:
                let ftyp: FileTypeBox = try decodeBox(boxbytes[0..<Int(size)].map{$0})
                boxes.append(ftyp)
            case .moov where !boxes.contains{$0 is MovieBox}:
                let moov: MovieBox = try decodeBox(boxbytes[0..<Int(size)].map{$0})
                boxes.append(moov)
            default:
                break
            }
        }
        return MP4(
            container: ISO14496Part12Container(
                ftyp: boxes.flatMap{$0 as? FileTypeBox}[0],
                moov: boxes.flatMap{$0 as? MovieBox}[0],
                mdat: boxes.flatMap{$0 as? MediaDataBox}[0]
            )
        )
    }
}
