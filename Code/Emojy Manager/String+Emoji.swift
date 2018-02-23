//
//  NSString+RemoveEmoji.swift
//  NSString+RemoveEmoji
//
//  Created by woxtu on 2017/01/07.
//  Copyright (c) 2017 woxtu. All rights reserved.
//

import Foundation

fileprivate let CombiningEnclosingKeycap: UInt32 = 0x20E3
fileprivate let VaridationSelector15: UInt32 = 0xFE0E
fileprivate let VaridationSelector16: UInt32 = 0xFE0F

public extension String {
    public func containsEmoji() -> Bool {
        let codepoints = (self as String).unicodeScalars.map { $0.value }
        
        if let first = codepoints.first, let last = codepoints.last {
            let isKeycapEmoji = last == CombiningEnclosingKeycap && codepoints.contains(VaridationSelector16)
            let isEmoji = CodePointSet.contains(first) && last != VaridationSelector15
            
            return isKeycapEmoji || isEmoji
        } else {
            return false
        }
    }
    
    public func replaceEmojiWithHexa() -> String
    {
        let buffer = NSMutableString(capacity: self.count)
        
        let range = self.startIndex ..< self.endIndex

        self.enumerateSubstrings(in:range, options: .byComposedCharacterSequences) { substring, _, _, _ in
            
            if let substring = substring
            {
                if !substring.containsEmoji()
                {
                    buffer.append(substring)
                }
                else
                {
                    let uni = substring.unicodeScalars // Unicode scalar values of the string
                    
                    let unicode = uni[uni.startIndex].value // First element as an UInt32
                    
                    let unicodeString = String(unicode)
                    
                    buffer.append(unicodeString)
                }
            }
        }
        
        return buffer as String
    }
}
