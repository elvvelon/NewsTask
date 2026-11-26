//
//  NetworkError.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import Foundation


enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)

    var errorDescription: String? {
        return switch self {
        case .invalidURL:                "Invalid request URL."
        case .invalidResponse(let code): "\(code) Server error."
        case .decodingError:             "Failed to process data."
        case .unknown(let error):        error.localizedDescription
        }
    }
}
