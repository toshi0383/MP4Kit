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
    public var meta: MetaBox?
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
                print("\(error)")
                break
            }
        }
        let trakBoxes = boxes.filter{$0.type == .trak}

        self.mvhd = try boxes <- MovieHeaderBox.self
        self.meta = try boxes <-? MetaBox.self
        self.traks = try trakBoxes <-| TrackBox.self
    }
    public override func bytes() throws -> [UInt8] {
        var bytes = try super.bytes()
        bytes += try mvhd.bytes()
        bytes += try traks.map{try $0.bytes()}.flatMap{$0}
        if let meta = meta {
            bytes += try meta.bytes()
        }
        return bytes
    }
}
