//
//  DimmingPresentationController.swift
//  CrossfitStocznia
//
//  Created by Jakub on 10.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import Foundation
import UIKit

class DimmingPresentationController: UIPresentationController {
  
  lazy var dimmingView = GradientView(frame: CGRect.zero)
  
  override func presentationTransitionWillBegin() {
    dimmingView.frame = containerView!.bounds
    containerView!.insertSubview(dimmingView, at: 0)
  }
  
  
  //dont remove previous screen (we see it in the background)
  override var shouldRemovePresentersView: Bool {
    return false
  }
  
  
}
