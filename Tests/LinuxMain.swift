import XCTest
@testable import MP4KitTests

XCTMain([
     testCase(BitSetTests.allTests),
     testCase(BitStreamEncodableTests.allTests),
     testCase(ByteReaderTests.allTests),
     testCase(ByteWriterTests.allTests),
     testCase(LargeSizeTests.allTests),
     testCase(MovieHeaderBoxTests.allTests),
     testCase(MP4KitTests.allTests),
])
