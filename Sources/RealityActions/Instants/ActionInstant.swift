//
//  ActionInstant.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Instant actions are immediate actions, base class for various
/// other classes like ``Call``, ``Hide``, ``Place``, ``RemoveSelf``,
/// ``Show``, ``ToggleVisibility``
public class ActionInstant: FiniteTimeAction {
    init () {
        super.init(duration: 0)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        ActionInstantState (action: self, target: target)
    }
    
    override public func reverse() -> FiniteTimeAction {
        ActionInstant ()
    }
}

class ActionInstantState: FiniteTimeActionState {
    override init(action: FiniteTimeAction, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override var isDone: Bool { true }
    
    override func step(dt: Float) {
        update (time: 1)
    }
    
    override func update(time: Float) {
        // ignore
    }
}

