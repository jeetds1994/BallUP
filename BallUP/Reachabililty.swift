//
//  checkInternet.swift
//  BallUP
//
//  Created by Diljeet Singh on 5/2/16.
//  Copyright © 2016 Diljeet Singh. All rights reserved.
//
//credit : http://stackoverflow.com/questions/30743408/check-for-internet-connection-in-swift-2-ios-9

import Foundation
import SystemConfiguration

open class Reachability {
    
//    class func isConnectedToNetwork() -> Bool {
//        
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
//        }
//        
//        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
//            return false
//        }
//        
//        let isReachable = flags == .reachable
//        let needsConnection = flags == .connectionRequired
//        
//        return isReachable && !needsConnection
//        
//    }
}
