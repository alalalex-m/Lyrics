protocol Then {}

extension Then where Self: Any {
    
    func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
    
    func `do`<T>(_ block: (Self) throws -> T) rethrows -> T {
        return try block(self)
    }
}

extension Then where Self: AnyObject {
    
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

#if canImport(Foundation)

import Foundation

extension NSObject: Then {}

#endif

#if canImport(CoreGraphics)

import CoreGraphics

extension CGPoint: Then {}
extension CGVector: Then {}
extension CGSize: Then {}
extension CGRect: Then {}
extension CGAffineTransform: Then {}

#endif

#if canImport(UIKit)

import UIKit.UIGeometry

extension UIEdgeInsets: Then {}
extension UIOffset: Then {}
extension UIRectEdge: Then {}

#endif

#if canImport(AppKit)

import AppKit

extension NSRectEdge: Then {}
extension NSEdgeInsets: Then {}
extension AlignmentOptions: Then {}

#endif

