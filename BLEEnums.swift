//
//  BLEEnums.swift
//  ParkingLock-iOS
//
//  Created by Rilwanul Huda on 30/03/23.
//

import Foundation

public enum LockHandleResult: String {
    case unlocked = "019e"
    case locked = "01ae"
}

public enum LockHandleResult2: String {
    case unlocked = "140101"
    case locked = "140102"
}

public enum LockStatus {
    case down
    case up
}

public enum LockActionHex: Equatable {
    case checkStatus(secretKey: String)
    case turnLockDown(secretKey: String)
    case turnLockUp(secretKey: String)
    case reset
    
    var parkingLockType1: String {
        switch self {
        case .checkStatus:
            return "0103100C000480CA"
        case .turnLockDown:
            return "01106008000102000106DE"
        case .turnLockUp:
            return "0110600700010200010621"
        case .reset:
            return "01106005000102000107C3"
        }
    }
    
    var parkingLockType2: String {
        switch self {
        case .checkStatus(let key):
            return "4444544314FF140201" + key + "45B80A"
        case .turnLockDown(let key):
            return "4444544314FF140101" + key + "45B80A"
        case .turnLockUp(let key):
            return "4444544314FF140102" + key + "45B80A"
        default:
            return ""
        }
    }
}

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

extension Data {
    func hexEncodedString() -> String {
        let hexDigits = Array("0123456789abcdef".utf16)
        var hexChars = [UTF16.CodeUnit]()
        hexChars.reserveCapacity(count * 2)
        
        for byte in self {
            let (index1, index2) = Int(byte).quotientAndRemainder(dividingBy: 16)
            hexChars.append(hexDigits[index1])
            hexChars.append(hexDigits[index2])
        }
        
        return String(utf16CodeUnits: hexChars, count: hexChars.count)
    }
}

public func TRACER(_ any: Any?) {
    #if DEBUG
    let trace = """
    Parking Lock Trace: \(any != nil ? any! : "nil")
    """
    print(trace)
    #endif
}
