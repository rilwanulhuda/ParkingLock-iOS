//
//  Ext+String.swift
//  ParkingLock-iOS
//
//  Created by Rilwanul Huda on 01/04/23.
//

import Foundation

extension String {
    var hexadecimal: Data? {
        var data = Data(capacity: self.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
    func isValidMacAddress() -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let pattern = "^[a-fA-F0-9]{2}(:[a-fA-F0-9]{2}){5}$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let matched = regex.firstMatch(in: self, options: [], range: range)
        return matched != nil
    }
    
    func toAdvertiseData() -> String {
        let str = self.replacingOccurrences(of: ":", with: "")
        var returnValue = ""
        var currentOffset = 0

        for _ in 0 ..< str.count / 2 {
            currentOffset -= 1
            let first = str.index(str.endIndex, offsetBy: currentOffset - 1)
            let second = str.index(str.endIndex, offsetBy: currentOffset)

            let firstSubstring = str[first]
            let secondSubString = str[second]
            let string = String(firstSubstring) + String(secondSubString)

            returnValue.append(string)
            currentOffset -= 1
        }
        return returnValue.lowercased()
    }

}
