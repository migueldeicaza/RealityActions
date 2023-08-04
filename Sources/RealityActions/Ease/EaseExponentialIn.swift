//
//  EaseExponentialIn.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: exponential in
public class EaseExponentialIn: ActionEase {
    public override init (action: FiniteTimeAction) {
        super.init(action: action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseExponentialInState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseExponentialOut (action: innerAction.reverse ())
    }
}

class EaseExponentialInState: ActionEaseState {
    init? (action: EaseExponentialIn, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: exponentialIn(time: time))
    }
}
