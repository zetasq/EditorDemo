//
//  UIFont+Util.swift
//  EditorDemo
//
//  Created by Zhu Shengqi on 2018/5/21.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

extension UIFont {
  
  public convenience init(preferredTextStyle: UIFontTextStyle, symbolicTraits: UIFontDescriptorSymbolicTraits) {
    let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: preferredTextStyle)
    let descriptorWithTrait = fontDescriptor.withSymbolicTraits(symbolicTraits)!
    self.init(descriptor: descriptorWithTrait, size: 0)
  }
  
}
