//
//  UIKitShowSidebar.swift
//  Zoetrope
//
//  Created by Andy Brown on 02/08/2022.
//

import SwiftUI
import UIKit

/// Required due to a SwiftUI issue where the sidebar doesn't show in portrait mode when there are no playlists.
/// See https://stackoverflow.com/questions/68807418/how-to-show-in-swiftui-the-sidebar-in-ipad-and-portrait-mode/69350695
struct UIKitShowSidebar: UIViewRepresentable {
  let showSidebar: Bool
  
  func makeUIView(context: Context) -> some UIView {
    let uiView = UIView()
    if self.showSidebar {
      DispatchQueue.main.async { [weak uiView] in
        uiView?.next(of: UISplitViewController.self)?
          .show(.primary)
      }
    } else {
      DispatchQueue.main.async { [weak uiView] in
        uiView?.next(of: UISplitViewController.self)?
          .show(.secondary)
      }
    }
    return uiView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    DispatchQueue.main.async { [weak uiView] in
      uiView?.next(
        of: UISplitViewController.self)?
        .show(showSidebar ? .primary : .secondary)
    }
  }
}

fileprivate extension UIResponder {
  func next<T>(of type: T.Type) -> T? {
    guard let nextValue = self.next else {
      return nil
    }
    guard let result = nextValue as? T else {
      return nextValue.next(of: type.self)
    }
    return result
  }
}
