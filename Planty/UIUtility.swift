//
//  UIUtility.swift
//  Planty
//
//  Created by Gunapandian on 05/04/18.
//  Copyright © 2018 Gunapandian. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

// MARK: - InstantPanGestureRecognizer

/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
public class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizerState.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizerState.began
    }
    
}


// MARK: - Slider Status
public enum SliderState {
    case Collapse
    case Expand
}

extension SliderState {
    var opposite: SliderState {
        switch self {
        case .Expand: return .Collapse
        case .Collapse: return .Expand
        }
    }
}
