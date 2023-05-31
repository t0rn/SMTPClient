//
//  EchoServer+defaultSuccessSMTPEcho.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation
import SMTPClient

extension EchoServer {
    class func defaultSuccessSMTPEcho(received data: Data) -> Data {
        String(describing: Response.StatusCode.ready)
            .appending(" ")
            .utf8 + data
    }
}
