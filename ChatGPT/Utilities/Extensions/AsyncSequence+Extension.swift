//
//  AsyncSequence+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 16-07-23.
//

import Foundation

// Reference: https://stackoverflow.com/a/76142791
extension AsyncSequence {
    func eraseToAsyncThrowingStream() -> AsyncThrowingStream<Element, Error> {
        var iterator = makeAsyncIterator()
        return AsyncThrowingStream(unfolding: { try await iterator.next() })
    }
}
