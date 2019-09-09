import Foundation

public struct Complex {
    let real: Double
    let imaginary: Double
    
    public var magnitudeSquared: Double {
        return real * real + imaginary * imaginary
    }
    
    public func scale(by rhs: Double) -> Complex {
        return self * rhs
    }
}

extension Complex: HasZero {
    public static var zero: Complex {
        return Complex(real: 0, imaginary: 0)
    }
    
    public static var one: Complex {
        return Complex(real: 1, imaginary: 0)
    }
    
    public static var i: Complex {
        return Complex(real: 0, imaginary: 1)
    }
}

extension Complex: AdditiveArithmetic {
    public static func += (lhs: inout Complex, rhs: Complex) {
        lhs = lhs + rhs
    }
    
    public static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }
    
    public static func - (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
    }
    
    public static func -= (lhs: inout Complex, rhs: Complex) {
        lhs = lhs - rhs
    }
}

extension Complex {
    public static func * (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real - lhs.imaginary * rhs.imaginary,
                       imaginary: lhs.real * rhs.imaginary + lhs.imaginary * rhs.real)
    }
    
    public static func * (complex: Complex, real: Double) -> Complex {
        return Complex(real: complex.real * real, imaginary: complex.imaginary * real)
    }
    
    public static func / (lhs: Complex, rhs: Double) -> Complex {
        return Complex(real: lhs.real / rhs, imaginary: lhs.imaginary / rhs)
    }
    
}

extension Complex: CustomStringConvertible {
    public var description: String {
        guard self != .zero else { return "0" }
        let real = self.real != 0 ? "\(self.real)" : nil
        let imag = self.imaginary != 0 ? "\(self.imaginary)i" : nil
        return [real, imag].compactMap({ $0 }).joined(separator: " + ")
    }
}

extension Complex: Equatable {
    public static func ==(lhs: Complex, rhs: Complex) -> Bool {
        return abs(lhs.real - rhs.real) + abs(lhs.imaginary - rhs.imaginary) < 1e-6
    }
    
}
