//
//  EaseExponentialInOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: exponential in-and-then-out
public class EaseExponentialInOut: ActionEase {
    public override init (action: FiniteTimeAction) {
        super.init(action: action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseExponentialInOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseExponentialInOut (action: innerAction.reverse ())
    }
}

class EaseExponentialInOutState: ActionEaseState {
    init? (action: EaseExponentialInOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: exponentialInOut(time: time))
    }
}
