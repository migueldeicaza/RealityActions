//
//  EaseBounceIn.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: bounce in
public class EaseBounceIn: ActionEase {
    public override init (_ action: FiniteTimeAction) {
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseBounceInState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseBounceOut (innerAction.reverse ())
    }
}

class EaseBounceInState: ActionEaseState {
    init? (action: EaseBounceIn, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        innerActionState.update (time: bounceIn (time: time))
    }
}
