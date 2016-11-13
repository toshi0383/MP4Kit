//
//  Box.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

// MP4Kit

enum BitStreamDecodeError: Error {
    case MissingKeyPath, TypeMismatch, Custom(String)
}

protocol BitStreamDecodable {
    static func decode(_ d: Data) throws -> Self
}

enum BoxType: String {
    case ftyp
}

protocol ByteFlags {
    var bytes: [Bool] {get}
}

protocol Box {
    var size: UInt32 {get}
    var type: BoxType {get}
}

protocol FullBox: Box {
    var version: UInt8 {get}
    var flags: ByteFlags {get}
}

struct FileTypeBox: Box, BitStreamDecodable {
    let size: UInt32
    let type = BoxType.ftyp
    let majorBrand: String
    let minorVersion: UInt32
    let compatibleBrands: [String]
    init(size: UInt32, majorBrand: String,
        minorVersion: UInt32, compatibleBrands: [String])
    {
        self.size = size
        self.majorBrand = majorBrand
        self.minorVersion = minorVersion
        self.compatibleBrands = compatibleBrands
    }
    static func decode(_ d: Data) throws -> FileTypeBox {
        let brandsStr: String = try extract(d[16..<d.endIndex].map{$0})
        return FileTypeBox(
            size: d[0..<4].map{$0}.uint32Value,
            majorBrand: try extract(d[8..<12].map{$0}),
            minorVersion: d[12..<16].map{$0}.uint32Value,
            compatibleBrands: brandsStr.slice(4)
        )
    }
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

struct ISOBMFFContainer {
    let ftyp: FileTypeBox
	init(path: String) throws {
		let reader = ByteReader(path: path)
        var boxes: [Box] = []
		while reader.hasNext() {
			guard let data: Data = reader.data(size: Constants.bufferSize) else {
                print("reader.data was nil")
                continue
            }
		    guard let (size, boxtype) = decodeBoxHeader(data) else {
                print("decodeBoxHeader(data) was nil")
				continue
			}

			switch boxtype {
			case .ftyp:
				let ftyp: FileTypeBox = try decodeBox(data)
                boxes.append(ftyp)
			}
			reader.seek(-Constants.bufferSize + Int(size))
		}
        print(boxes)
        self.ftyp = boxes.flatMap{$0 as? FileTypeBox}[0]
	}
}

struct MP4 {
    let container: ISOBMFFContainer
    init(path: String) throws {
        self.container = try ISOBMFFContainer(path: path)
    }
}

