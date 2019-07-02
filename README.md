# SwiftyGFX

A swift graphics library intended for my SwiftyOLED library.

## Key features

* Ability to use any font in _.ttf_ or _.otf_

## TODO

* Add `.fill()` and `.filled()`
* Write unit tests that makes sense
* Provide a defualt path to look for fonts
* Add more triangle initializers (using trigonometry magic to extrapolate data)

## Documentation

#### Orthogonal coordinate system

This library uses iOS like coordinate system. The X axis is increasing to the right. The Y axis is increasing downwards.

### Primitives

#### Lines

```swift
    ObliqueLine(from origin: Point, to endPoint: Point)
    HorizontalLine(from origin: Point, lenght: Int)
    VerticalLine(from origin: Point, lenght: Int)
```

### Rectangles

```swift
    Rectangle(at origin: Point, height: Int, width: Int)
    Square(at origin: Point, sideSize a: Int)
```

### Ellipses

```swift
    Ellipse(at origin: Point, yRadius: Int, xRadius: Int)
    Ellipse(at origin: Point, height: Int, width: Int)
    Circle(at origin: Point, radius: Int)
    Circle(at origin: Point, width: Int)
```

### Triangle

```swift
    Triangle(at origin: Point, corner1: Point, corner2: Point, corner3: Point)
```

### Text

```swift
    Text(_ text: String, font pathToFont: String, at origin: Point, pixelHeight: UInt32 = 16, pixelWidth: UInt32 = 16)

```

## Contributing

