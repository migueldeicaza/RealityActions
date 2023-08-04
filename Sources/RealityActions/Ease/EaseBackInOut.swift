//
//  EaseBackInOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: back in and out
public class EaseBackInOut: ActionEase {
    public override init (_ action: FiniteTimeAction) {
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseBackInOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseBackInOut (innerAction.reverse ())
    }
}

class EaseBackInOutState: ActionEaseState {
    init? (action: EaseBackInOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: backInOut (time: time))
    }
}
