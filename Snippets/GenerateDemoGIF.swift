import Foundation
import Logging
import GIF

LoggingSystem.bootstrap {
    GIFLogHandler(label: $0)
}

guard let outputPath = CommandLine.arguments.dropFirst().first else {
    print("Usage: \(CommandLine.arguments[0]) <output path>")
    exit(1)
}

let url = URL(fileURLWithPath: outputPath)

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
gif.frames.append(.init(image: image, delayTime: 100))

try gif.encoded().write(to: url)
