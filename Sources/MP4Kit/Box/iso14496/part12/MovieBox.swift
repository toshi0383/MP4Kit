//
//  MovieBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/14.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class MovieBox: BoxBase {
    public var mvhd: MovieHeaderBox!
    public var traks: [TrackBox] = []
    public override class func boxType() -> BoxType { return .moov }
    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        var boxes: [IntermediateBox] = []
        while b.hasNext() {
            do {
                // Store bytes on IntermediateBox, not parsed yet.
                // IntermediateBox knows only size(UInt64) and type(BoxType).
                boxes.append(try IntermediateBox(bytes: try b.nextBoxBytes()))
            } catch {
                break
            }
        }
        let trakBoxes = boxes.filter{$0.type == .trak}

        self.mvhd = try boxes <- MovieHeaderBox.self
        self.traks = try trakBoxes <-| TrackBox.self
    }
    public override func encode() throws -> [UInt8] {
        var bytes = try super.encode()
        bytes += try mvhd.encode()
        bytes += try traks.map{try $0.encode()}.flatMap{$0}
        return bytes
    }
}
