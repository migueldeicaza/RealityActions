//
//  DelayTime.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// An action which completes after the specified time.
public class DelayTime: FiniteTimeAction {
    public override init (duration: Float) {
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return DelayTimeState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        return DelayTime (duration: duration)
    }
}

class DelayTimeState: FiniteTimeActionState {
    init(action: DelayTime, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
    }
}
