//
//  EaseInOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: ease-in-and-then-out
public class EaseInOut: EaseRateAction {
    public override init (_ action: FiniteTimeAction, rate: Float) {
        super.init(action, rate: rate)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseInOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseInOut (innerAction.reverse (), rate: rate)
    }
}

class EaseInOutState: EaseRateActionState {
    init? (action: EaseInOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        let atime = time * 2
        if atime < 2 {
            innerActionState.update (time: 0.5 * powf (atime, rate))
        } else {
            innerActionState.update (time: 1 - 0.5 * powf (2-atime, rate))
        }
    }
}
