//
//  Show.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// This actions sets the `isEnabled` property to true, causing the entity to be shown
public class Show: ActionInstant {
    override func startAction(target: Entity) -> ActionState? {
        ShowState (action: self, target: target)
    }
    
    override public func reverse() -> FiniteTimeAction {
        Hide()
    }
}

class ShowState: ActionInstantState {
    override init(action: FiniteTimeAction, target: Entity) {
        super.init(action: action, target: target)
        target.isEnabled = true
    }
}

