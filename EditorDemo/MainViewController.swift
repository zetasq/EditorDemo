//
//  ViewController.swift
//  EditorDemo
//
//  Created by Zhu Shengqi on 2018/5/20.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  private let textView: UITextView = {

    let initialText = "Hello world!"
    let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.preferredFont(forTextStyle: .body)]
    let attrString = NSAttributedString(string: initialText, attributes: attrs)
    let textStorage = CustomTextStorage()
    textStorage.append(attrString)
    
    let layoutManager = NSLayoutManager()
    
    let containerSize = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
    let container = NSTextContainer(size: containerSize)
    container.widthTracksTextView = true
    layoutManager.addTextContainer(container)
    textStorage.addLayoutManager(layoutManager)
    
    let textView = UITextView(frame: .zero, textContainer: container)
    
    return textView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  private func setupUI() {
    title = "Editor"
    view.backgroundColor = .blue
    
    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
      textView.widthAnchor.constraint(equalToConstant: 200),
      textView.heightAnchor.constraint(equalToConstant: 200)
      ])
    
    textView.delegate = self
  }

}

extension MainViewController: UITextViewDelegate {
  
}

