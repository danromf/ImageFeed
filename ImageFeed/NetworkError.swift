//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Даниил Романов on 06.07.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case makeRequestError
    case urlRequestError(Error)
    case urlSessionError
    case decodingError(Error)
}
