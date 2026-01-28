//
//  CachedAttachment.swift
//  Copyright © 2026 Jason Fieldman.
//

public protocol CachedObjectAttaching: AnyObject {
    func cachedAttachment<T>(key: inout Int, factory: () -> T?) -> T?
    func cachedAttachment<T, I>(key: inout Int, input: I, factory: (I) -> T?) -> T?
}

public extension CachedObjectAttaching {
    func cachedAttachment<T>(key: inout Int, factory: () -> T) -> T {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if let cacheBox = objc_getAssociatedObject(self, &key) as? CachedAttachmentBox<T> {
            return cacheBox.value
        }

        let newValue = factory()
        let cacheBox = CachedAttachmentBox(newValue)
        objc_setAssociatedObject(self, &key, cacheBox, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return newValue
    }

    func cachedAttachment<T, I>(key: inout Int, input: I, factory: (I) -> T) -> T {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if let cacheBox = objc_getAssociatedObject(self, &key) as? CachedAttachmentBox<T> {
            return cacheBox.value
        }

        let newValue = factory(input)
        let cacheBox = CachedAttachmentBox(newValue)
        objc_setAssociatedObject(self, &key, cacheBox, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return newValue
    }
}

class CachedAttachmentBox<T> {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}
