#!/usr/bin/swift

import Cocoa

/* Example of Swift syntax */

/// A documentation comment of the following declaration.
protocol ProtocolName {}

@available(*, noasync)
class ClassName: ProtocolName {
    static func Greeting(person name: String) -> String {
        return "hello\t\(name): \invalid"
    }
}

actor ActorName {}

enum EnumName { case First, Second }
            
typealias MyTypeAlias = ProtocolName

struct StructName { 
    var s: [EnumName?]
    func methodName() { let enumName = EnumName.First }
    func assign(value: EnumName) { self.s = value }
}

protocol ProtocolAssociated {
    associatedtype Value: MyTypeAlias
    
    func getValue() -> Value
}

extension ProtocolAssociated {
    func printValue() {
        let structValue = StructName();
        let value = getValue();
        structValue.methodName()
        print(value)
    }
    
    func something(value: Collection<String>) {
        let it = value.makeIterator()
    }
}

#if swift(>=5.5)
    func swiftVersion() { print("new swift") }
#elseif DEBUG
    func swiftVersion() { print("old swift with DEBUG") }
#else               
    func swiftVersion() { print("old swift") }
#endif

// hello world
func greeting() {
    print(ClassName.Greeting())
}
