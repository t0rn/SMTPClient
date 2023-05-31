//
//  NWParameters+TLSv12.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation
import Network

public extension NWParameters {
    static var TLSv12: NWParameters {
        let tlsOptions = NWProtocolTLS.Options()
        sec_protocol_options_set_min_tls_protocol_version(tlsOptions.securityProtocolOptions, .TLSv12)
        return NWParameters(tls: tlsOptions)
    }
}
