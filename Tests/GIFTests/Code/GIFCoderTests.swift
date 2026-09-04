import XCTest
import Logging
@testable import InlineGIF

fileprivate let log = Logger(label: "GIFTests.GIFCoderTests")

final class GIFCoderTests: XCTestCase {
    override func setUp() {
        XCTAssert(isLoggingConfigured)
    }

    func testGIFCoder() throws {
        for resource in ["mini", "mandelbrot"] {
            log.info("Testing GIF en-/decoder with \(resource).gif...")

            let url = Bundle.module.url(forResource: resource, withExtension: "gif")!
            let data = try Data(contentsOf: url)
            let gif = try GIF(data: data) // Try decoding the GIF
            let reEncoded = try gif.encoded() // Try encoding it again
            let reDecoded = try GIF(data: reEncoded) // Try decoding it again

            for (frame1, frame2) in zip(gif.frames, reDecoded.frames) {
                assertImagesEqual(frame1.image, frame2.image)
                XCTAssertEqual(frame1.delayTime, frame2.delayTime)
            }
        }
    }

    func testInMemoryRGBARoundTrip() throws {
        let image = GIFImage(
            width: 2,
            height: 2,
            rgba: [
                255, 0, 0, 255,
                0, 255, 0, 255,
                0, 0, 255, 255,
                0, 0, 0, 0,
            ]
        )
        var gif = GIF(quantizingImage: image)
        gif.frames.append(Frame(image: image))

        let decoded = try GIF(data: gif.encoded())

        XCTAssertEqual(decoded.width, 2)
        XCTAssertEqual(decoded.height, 2)
        XCTAssertEqual(decoded.frames.count, 1)
        XCTAssertEqual(decoded.frames[0].image.width, 2)
        XCTAssertEqual(decoded.frames[0].image.height, 2)
    }

    private func assertImagesEqual(_ image1: GIFImage, _ image2: GIFImage) {
        XCTAssertEqual(image1.width, image2.width)
        XCTAssertEqual(image1.height, image2.height)

        for index in 0..<(image1.width * image1.height) {
            let color1 = image1.color(at: index)
            let color2 = image2.color(at: index)

            // Only assert equality on fully non-transparent
            // pixels since these not affected by GIFs (potentially
            // lossy) encoding of transparent pixels.
            if image1.alpha(at: index) == 255 && image2.alpha(at: index) == 255 {
                XCTAssertEqual(color1, color2)
            }
        }
    }
}
