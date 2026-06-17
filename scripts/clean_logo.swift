import AppKit
import Foundation

let inputPath = CommandLine.arguments[1]
let outputPath = CommandLine.arguments[2]

guard let image = NSImage(contentsOfFile: inputPath),
      let tiffData = image.tiffRepresentation,
      let sourceRep = NSBitmapImageRep(data: tiffData) else {
  fatalError("Could not read input image")
}

let width = sourceRep.pixelsWide
let height = sourceRep.pixelsHigh
let rep = NSBitmapImageRep(
  bitmapDataPlanes: nil,
  pixelsWide: width,
  pixelsHigh: height,
  bitsPerSample: 8,
  samplesPerPixel: 4,
  hasAlpha: true,
  isPlanar: false,
  colorSpaceName: .deviceRGB,
  bytesPerRow: 0,
  bitsPerPixel: 0
)!

func isGold(_ color: NSColor) -> Bool {
  let c = color.usingColorSpace(.deviceRGB) ?? color
  let r = c.redComponent
  let g = c.greenComponent
  let b = c.blueComponent
  return r > 0.48 && g > 0.30 && g < 0.82 && b < 0.30
}

func isRedMarkup(_ color: NSColor) -> Bool {
  let c = color.usingColorSpace(.deviceRGB) ?? color
  return c.redComponent > 0.72 && c.greenComponent < 0.34 && c.blueComponent < 0.24
}

var lastBoundary = width - 1

for y in 0..<height {
  var boundary: Int? = nil
  for x in stride(from: width - 1, through: 0, by: -1) {
    if let color = sourceRep.colorAt(x: x, y: y), isGold(color), x > Int(Double(width) * 0.72) {
      boundary = min(width - 1, x + 2)
      break
    }
  }

  if let boundary {
    lastBoundary = boundary
  }

  let rowBoundary = lastBoundary

  for x in 0..<width {
    guard var color = sourceRep.colorAt(x: x, y: y)?.usingColorSpace(.deviceRGB) else {
      continue
    }

    if x > rowBoundary || isRedMarkup(color) {
      color = NSColor(calibratedRed: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: 0)
    }

    rep.setColor(color, atX: x, y: y)
  }
}

guard let pngData = rep.representation(using: .png, properties: [:]) else {
  fatalError("Could not create PNG")
}

try pngData.write(to: URL(fileURLWithPath: outputPath))
