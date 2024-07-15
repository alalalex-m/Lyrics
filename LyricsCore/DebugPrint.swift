#if DEBUG

public func dprint(file: String = #file, line: Int = #line, function: String = #function) {
    print(file.components(separatedBy: "/").last!, "\(line)", function)
}

public func dprint(file: String = #file, line: Int = #line, function: String = #function, _ item: @autoclosure () -> Any) {
    print(file.components(separatedBy: "/").last!, "\(line)", function, "\(item())")
}

public func dprint(file: String = #file, line: Int = #line, function: String = #function, _ items: Any...) {
    var itemStrings = ""
    if items.count > 1 {
        items.forEach {
            itemStrings += "\($0) "
        }
    } else if let item = items.first {
        itemStrings = "\(item)"
    }
    print(file.components(separatedBy: "/").last!, "\(line)", function, itemStrings)
}

#else

public func dprint() {
}

public func dprint(_ item: @autoclosure () -> Any) {
}

public func dprint(_ items: Any...) {
}

#endif
