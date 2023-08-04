//
//  EaseSinInOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: ease sin in-and-then-out
public class EaseSinInOut: ActionEase {
    public override init (_ action: FiniteTimeAction) {
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseSinInOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseSinInOut (innerAction.reverse ())
    }
}

class EaseSinInOutState: ActionEaseState {
    init? (action: EaseSinInOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: sineInOut (time: time))
    }
}
