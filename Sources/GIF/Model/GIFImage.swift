/// A compact, in-memory image used by GIF frames.
///
/// Pixels are stored in row-major RGBA order, with four bytes per pixel.
public struct GIFImage: Equatable, Sendable {
    public let width: Int
    public let height: Int
    public let rgba: [UInt8]

    public init(width: Int, height: Int, rgba: [UInt8]) {
        precondition(width >= 0)
        precondition(height >= 0)
        precondition(rgba.count == width * height * 4)

        self.width = width
        self.height = height
        self.rgba = rgba
    }

    func color(at index: Int) -> GIFColor {
        let offset = index * 4
        return GIFColor(red: rgba[offset], green: rgba[offset + 1], blue: rgba[offset + 2])
    }

    func alpha(at index: Int) -> UInt8 {
        rgba[(index * 4) + 3]
    }
}

/// An RGB entry in a GIF color table.
public struct GIFColor: Hashable, Sendable {
    public var red: UInt8
    public var green: UInt8
    public var blue: UInt8

    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
