//
//  KeychainError.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 4/2/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
