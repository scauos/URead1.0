//
//  SafeDispatch.swift
//  uread
//
//  Created by Hao Dong on 9/17/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation

public class SafeDispatch {
    
    private let mainQueueKey = UnsafeMutablePointer<Void>.alloc(1)
    private let mainQueueValue = UnsafeMutablePointer<Void>.alloc(1)
    
    private static let sharedSafeDispatch = SafeDispatch()
    
    private init() {
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueValue, nil)
    }
    
    public class func async(onQueue queue: dispatch_queue_t = dispatch_get_main_queue(), forWork block: dispatch_block_t) {
        if queue === dispatch_get_main_queue() {
            if dispatch_get_specific(sharedSafeDispatch.mainQueueKey) == sharedSafeDispatch.mainQueueValue {
                block()
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    block()
                }
            }
        } else {
            dispatch_async(queue) {
                block()
            }
        }
    }
}
