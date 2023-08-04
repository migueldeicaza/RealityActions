//
//  ActionEase.swift
//  
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Base class for all the Action Easing functions.
/// In general, you will be using one of the `Ease` actions
public class ActionEase: FiniteTimeAction {
    let innerAction: FiniteTimeAction
    
    public init (_ action: FiniteTimeAction)
    {
        innerAction = action
        super.init(duration: action.duration)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        ActionEaseState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        ActionEase (innerAction.reverse())
    }
}

class ActionEaseState : FiniteTimeActionState {
    var innerActionState: FiniteTimeActionState
    
    init? (action: ActionEase, target: Entity)
    {
        guard let inner = action.innerAction.startAction(target: target) as? FiniteTimeActionState else {
            return nil
        }
        innerActionState = inner
        super.init(action: action, target: target)
    }

    override func stop() {
        innerActionState.stop ()
        super.stop()
    }
    
    override func update(time: Float) {
        innerActionState.update (time: time)
    }
}
