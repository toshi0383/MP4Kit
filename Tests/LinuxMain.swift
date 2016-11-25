import XCTest
@testable import MP4KitTests

XCTMain([
     testCase(BitStreamEncodableTests.allTests),
     testCase(ByteReaderTests.allTests),
     testCase(ByteWriterTests.allTests),
     testCase(LargeSizeTests.allTests),
     testCase(MP4KitTests.allTests),
])
