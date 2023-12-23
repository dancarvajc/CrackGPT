//
//  String+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 22-04-23.
//

import Foundation

extension StringProtocol {
    func ranges(of targetString: Self, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {
        let result: [Range<String.Index>] = indices.compactMap { startIndex in
            let targetStringEndIndex = index(startIndex, offsetBy: targetString.count, limitedBy: endIndex) ?? endIndex
            return range(of: targetString, options: options, range: startIndex ..< targetStringEndIndex, locale: locale)
        }
        return result
    }
}

extension String {
    // MARK: Powered by ChatGPT 4 Turbo

    func separateCodeBlocks() -> [String] {
        let code = self
        var codeBlocks = code.ranges(of: "```")

        if !codeBlocks.isEmpty {
            var result: [String] = []
            var lastIndex = code.startIndex

            if codeBlocks.count % 2 != 0 {
                codeBlocks.append(code.endIndex ..< code.endIndex)
            }

            for i in stride(from: 0, to: codeBlocks.count, by: 2) {
                let preCode = String(code[lastIndex ..< codeBlocks[i].lowerBound])
                result.append(preCode)

                if i + 1 < codeBlocks.count {
                    let codeBlockRange = codeBlocks[i].lowerBound ..< codeBlocks[i + 1].upperBound
                    let codeBlock = String(code[codeBlockRange])
                    result.append(codeBlock)

                    lastIndex = codeBlocks[i + 1].upperBound
                }
            }

            if lastIndex != code.endIndex {
                let postCode = String(code[lastIndex ..< code.endIndex])
                result.append(postCode)
            }

            return result
        } else {
            return [code]
        }
    }
}

extension String: Identifiable {
    public var id: Self { self }
}
