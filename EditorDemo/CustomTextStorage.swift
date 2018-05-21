//
//  CustomTextStorage.swift
//  EditorDemo
//
//  Created by Zhu Shengqi on 2018/5/20.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

public final class CustomTextStorage: NSTextStorage {
  
  private let backingStore = NSMutableAttributedString()
  
  private var replacements: [String: [NSAttributedStringKey: Any]]
  
  public override init() {
    let scriptFontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Zapfino"])
    
    // Base our script font on the preferred body font size
    let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
    let bodyFontSize = bodyFontDescriptor.fontAttributes[.size] as! CGFloat
    let scriptFont = UIFont(descriptor: scriptFontDescriptor, size: bodyFontSize)
    
    let boldAttributes: [NSAttributedStringKey: Any] = [.font: UIFont(preferredTextStyle: .body, symbolicTraits: .traitBold)]
    let italicAttributes: [NSAttributedStringKey: Any] = [.font: UIFont(preferredTextStyle: .body, symbolicTraits: .traitItalic)]
    let strikeThroughAttributes: [NSAttributedStringKey: Any] = [.strikethroughStyle: 1]
    let scriptAttributes: [NSAttributedStringKey: Any] = [.font: scriptFont]
    let redTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.red]
    
    replacements = [
      "(\\*\\w+(\\s\\w+)*\\*)" : boldAttributes,
      "(_\\w+(\\s\\w+)*_)" : italicAttributes,
      "([0-9]+\\.)\\s" : boldAttributes,
      "(-\\w+(\\s\\w+)*-)" : strikeThroughAttributes,
      "(~\\w+(\\s\\w+)*~)" : scriptAttributes,
      "\\s([A-Z]{2,})\\s" : redTextAttributes
    ]
    
    super.init()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var string: String {
    return backingStore.string
  }
  
  // MARK: - NSTextStorage overrides needed
  public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any] {
    return backingStore.attributes(at:location, effectiveRange:range)
  }
  
  public override func replaceCharacters(in range: NSRange, with str: String) {
    print("replaceCharactersInRange:\(range) withString:\(str)")
    
    beginEditing()
    backingStore.replaceCharacters(in: range, with: str)
    edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
    endEditing()
  }
  
  public override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange) {
    print("setAttributes:\(attrs ?? [:]) range:\(range)")
    
    beginEditing()
    backingStore.setAttributes(attrs, range: range)
    edited(.editedAttributes, range: range, changeInLength: 0)
    endEditing()
  }
  
  // MARK: - Custom behavior for NSTextStrorage
  public override func processEditing() {
    performReplacements(for: editedRange)
    super.processEditing()
  }
  
  
  
  // MARK: - Helper methods
  private func applyStyles(in searchRange: NSRange) {
    let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
    let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)!
    let boldFont = UIFont(descriptor: boldFontDescriptor, size: 0)
    let normalFont = UIFont.preferredFont(forTextStyle: .body)
    
    let regex = try! NSRegularExpression(pattern: "(\\*\\w+(\\s\\w+)*\\*)", options: [])
    let boldAttributes: [NSAttributedStringKey: Any] = [.font: boldFont]
    let normalAttributes: [NSAttributedStringKey: Any] = [.font: normalFont]
    
    regex.enumerateMatches(in: backingStore.string, options: [], range: searchRange) { match, flags, stop in
      let matchRange = match!.range(at: 1)
      
      addAttributes(boldAttributes, range: matchRange)
      
      // This ensures that any text added after the closing asterisk is not rendered in bold type.
      let maxLoc = NSMaxRange(matchRange)
      if maxLoc + 1 < self.length {
        addAttributes(normalAttributes, range: NSMakeRange(maxLoc, 1))
      }
    }
    
  }
  
  private func performReplacements(for changedRange: NSRange) {
    let string = NSString(string: backingStore.string)
    let extendedRangeForBeginningLine = string.lineRange(for: NSRange(location: changedRange.location, length: 0))
    let extendedRangeForEndingLine = string.lineRange(for: NSRange(location: NSMaxRange(changedRange), length: 0))
    
    let totalExtendedRange = changedRange.union(extendedRangeForBeginningLine).union(extendedRangeForEndingLine)
    applyStyles(in: totalExtendedRange)
  }
      
}
