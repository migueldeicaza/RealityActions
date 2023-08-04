//
//  EaseExponentialOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: exponential out
public class EaseExponentialOut: ActionEase {
    public override init (action: FiniteTimeAction) {
        super.init(action: action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseExponentialOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseExponentialIn (action: innerAction.reverse ())
    }
}

class EaseExponentialOutState: ActionEaseState {
    init? (action: EaseExponentialOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: exponentialOut (time: time))
    }
}
