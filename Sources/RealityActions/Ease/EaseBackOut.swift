//
//  EaseBackOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: back out
public class EaseBackOut: ActionEase {
    public override init (_ action: FiniteTimeAction) {
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseBackOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseBackIn (innerAction.reverse ())
    }
}

class EaseBackOutState: ActionEaseState {
    init? (action: EaseBackOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: backOut (time: time))
    }
}
