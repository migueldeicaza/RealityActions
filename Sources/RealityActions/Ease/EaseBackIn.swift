//
//  EaseBackIn.swift
//  
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: back in
public class EaseBackIn: ActionEase {
    public override init (_ action: FiniteTimeAction) {
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseBackInState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseBackOut (innerAction.reverse ())
    }
}

class EaseBackInState: ActionEaseState {
    init? (action: EaseBackIn, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: backIn (time: time))
    }
}
