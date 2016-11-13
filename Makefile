BUILD_TOOL?=xcodebuild
XCODEFLAGS=-project 'MP4Kit.xcodeproj' \
	-scheme 'MP4Kit' \

.PHONY: clean test

test: clean
	$(BUILD_TOOL) $(XCODEFLAGS) test

clean:
	$(BUILD_TOOL) $(XCODEFLAGS) -configuration Debug clean
	$(BUILD_TOOL) $(XCODEFLAGS) -configuration Release clean
