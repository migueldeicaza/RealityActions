//
//  EaseOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: ease-out
public class EaseOut: EaseRateAction {
    public override init (_ action: FiniteTimeAction, rate: Float) {
        super.init(action, rate: rate)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseOut (innerAction.reverse (), rate: 1/rate)
    }
}

class EaseOutState: EaseRateActionState {
    init? (action: EaseOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: powf(time, 1/rate))
    }
}
