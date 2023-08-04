//
//  Spawn.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Spawn a new action immediately
public class Spawn: FiniteTimeAction {
    let action1: FiniteTimeAction
    let action2: FiniteTimeAction
    
    init (action1: FiniteTimeAction, action2: FiniteTimeAction) {
        if action1.duration > action2.duration {
            self.action1 = action1
            self.action2 = SequenceAction(first: action2, second: DelayTime(duration: action1.duration-action2.duration))
        } else if action1.duration != action2.duration {
            self.action1 = SequenceAction(first: action1, second: DelayTime(duration: action2.duration-action1.duration))
            self.action2 = action2
        } else {
            self.action1 = action1
            self.action2 = action2
        }
        super.init(duration: max (action1.duration, action2.duration))
    }
    
    public convenience init? (_ actions: FiniteTimeAction...) {
        self.init(actions.compactMap { $0 })
    }
    
    public convenience init? (_ actions: [FiniteTimeAction]) {
        switch actions.count {
        case 0:
            self.init (action1: ExtraAction (duration: 0), action2: ExtraAction(duration: 0))
        case 1:
            self.init (action1: actions [0], action2: ExtraAction(duration: 0))
        default:
            var prev = actions [0]
            for i in 1..<actions.count {
                prev = Spawn (action1: prev, action2: actions [i])
            }
            self.init(action1: prev, action2: actions [actions.count-1])
        }
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return SpawnState (action: self, target: target)
    }
    
    override public func reverse() -> FiniteTimeAction {
        Spawn (action1: action1.reverse(), action2: action2.reverse())
    }
}

class SpawnState: FiniteTimeActionState {
    let a1state, a2state: FiniteTimeActionState?
    init(action: Spawn, target: Entity) {
        a1state = action.action1.startAction(target: target) as? FiniteTimeActionState
        a2state = action.action2.startAction(target: target) as? FiniteTimeActionState
        
        super.init(action: action, target: target)
    }
    
    override func stop() {
        a1state?.stop()
        a2state?.stop()
        super.stop()
    }
    override func update(time: Float) {
        guard target != nil else { return }
        a1state?.update(time: time)
        a2state?.update(time: time)
    }
}
