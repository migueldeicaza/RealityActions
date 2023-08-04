//
//  ReverseTime.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// This action reverses time for the nested action
public class ReverseTime: FiniteTimeAction
{
    let other: FiniteTimeAction
    
    public init (action: FiniteTimeAction) {
        other = action
        super.init(duration: action.duration)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        ReverseTimeState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        other
    }
}

class ReverseTimeState: FiniteTimeActionState {
    var other: FiniteTimeAction
    var otherState: FiniteTimeActionState
    
    init? (action: ReverseTime, target: Entity) {
        other = action.other
        guard let otherState = other.startAction(target: target) as? FiniteTimeActionState else {
            return nil
        }
        self.otherState = otherState
        super.init(action: action, target: target)
    }
    
    override func stop() {
        otherState.stop()
    }
    
    override func update(time: Float) {
        otherState.update(time: 1-time)
    }
}
