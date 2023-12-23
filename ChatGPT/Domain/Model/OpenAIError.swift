//
//  Errors.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 03-12-23.
//

import Foundation

enum OpenAIError: String {
    case contextLengthExceeded = "context_length_exceeded"
    case invalidApiKey = "invalid_api_key"
    case invalidRequestError = "invalid_request_error"
    case modelNotFound = "model_not_found"
}
