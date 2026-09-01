// Single line comment
/*
 Block comment
 */

/// Documentation comment for the module
import Foundation

@available(iOS 15, *)
public class Animal {
    private var name: String
    let legs: Int

    init(name: String, legs: Int) {
        self.name = name
        self.legs = legs
    }

    func speak() -> String {
        return "..."
    }
}

struct Point {
    var x: Double
    var y: Double

    mutating func translate(dx: Double, dy: Double) {
        x += dx
        y += dy
    }
}

enum Direction {
    case north, south, east, west
}

protocol Describable {
    func describe() -> String
}

extension Point: Describable {
    func describe() -> String {
        return "(\(x), \(y))"
    }
}

// Control flow
func fibonacci(n: Int) -> Int {
    guard n > 1 else { return n }
    return fibonacci(n: n - 1) + fibonacci(n: n - 2)
}

let values = [1, 2, 3, 4, 5]
for value in values {
    print(value)
}

switch direction {
case .north:
    print("Going north")
default:
    break
}

// Error handling
do {
    let result = try loadData()
} catch {
    print("Error: \(error)")
}

// Compiler directives
#if os(iOS)
let platform = "iOS"
#endif

// Closures and optionals
let doubled = values.map { $0 * 2 }
let greeting: String? = nil
let message = greeting ?? "Hello, World!"

// Async/await
func fetchData() async throws -> Data {
    let url = URL(string: "https://example.com")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}

// Constants
let isReady = true
let count: Int? = nil
let pi = 3.14159
let hex = 0xFF

