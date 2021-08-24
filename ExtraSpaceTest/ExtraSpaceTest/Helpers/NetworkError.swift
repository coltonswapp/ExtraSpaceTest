//
//  NetworkError.swift
//  ExtraSpaceTest
//
//  Created by Colton Swapp on 8/24/21.
//

import UIKit

enum NetworkError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unknownIssue
    
    var errorDescription: String? {
        switch self {
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .invalidURL:
            return "Unable to reach the server."
        case .noData:
            return "The server responded with no data."
        case .unknownIssue:
            return "Server responed with a non-200 status code."
        }
    }
}//End of enum

