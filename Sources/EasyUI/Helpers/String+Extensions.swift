//
//  File.swift
//  
//
//  Created by Phanith on 30/1/22.
//

import UIKit

extension String {
  public var isNotEmpty: Bool { !isEmpty }
  
  public var doubleValue: Double {
      let value = replacingOccurrences(of: ",", with: ".")
      return Double(value) ?? 0.0
  }
  
  public var isPhoneNumber: Bool {
    do {
      let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
      let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
      if let res = matches.first {
        return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && (self.count >= 9 && self.count <= 10) && self.first == "0" && !self.hasPrefix("00")
      } else {
        return false
      }
    } catch {
      return false
    }
  }
  
  public var formattedPhoneNumber: String {
    applyPatternOnNumbers(pattern: "### ### ####", replacmentCharacter: "#")
  }
  
  public func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
    var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    for index in 0 ..< pattern.count {
      guard index < pureNumber.count else { return pureNumber }
      let stringIndex = String.Index(utf16Offset: index, in: self)//String.Index(encodedOffset: index)
      let patternCharacter = pattern[stringIndex]
      guard patternCharacter != replacmentCharacter else { continue }
      pureNumber.insert(patternCharacter, at: stringIndex)
    }
    return pureNumber
  }
  
  public func replaceCommaWithDot(using string: String, in range: NSRange) -> Bool {
    let oldText = replacingOccurrences(of: ",", with: ".")
    if let r = Range(range, in: oldText) {
      let newString = string.replacingOccurrences(of: ",", with: ".")
      let newText = oldText.replacingCharacters(in: r, with: newString)
      let isNumeric = newText.isEmpty || (Double(newText) != nil)
      let numberOfDots = newText.components(separatedBy: ".").count - 1
      
      let numberOfDecimalDigits: Int
      if let dotIndex = newText.firstIndex(of: ".") {
        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
      } else {
        numberOfDecimalDigits = 0
      }
      
      return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    } else {
      return true
    }
  }
  
  public func toUniversalNumber() -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "km-KH")
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    
    var str: String = self
    let universalNumerals = (0...9).map { String($0) }
    let khmerNumerals = ["០", "១", "២", "៣", "៤", "៥", "៦", "៧", "៨", "៩"]
    let zipped = zip(universalNumerals, khmerNumerals)
    let range = NSRange(location: 0, length: (str as NSString).length)
    
    zipped.forEach { universal, khmer in
      do {
        let regex = try NSRegularExpression(pattern: khmer, options: .caseInsensitive)
        str = regex.stringByReplacingMatches(in: str, options: .reportCompletion, range: range, withTemplate: universal)
      } catch {
        print(error)
      }
    }
    return str
  }
}
