//
//  ReachabilityService.swift
//  The Write-Down Dictionary
//
//  Created by Parshakov Alexander on 8/29/20.
//  Copyright © 2020 ParshakovAlexander. All rights reserved.
//

import Foundation
import SystemConfiguration

final class ReachabilityService: NSObject {
    static private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    
    static func isConnectionAvailable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        return isNetworkReachable(with: flags)
    }
    
    static private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}
