//
//  Parallel.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Runs the provided nested actions in parallel
public class Parallel: FiniteTimeAction {
    let actions: [FiniteTimeAction]
    
    /// Creates a parallel action
    /// - Parameter actions: The nested actions that will be ran in parallel.
    public convenience init (_ actions: FiniteTimeAction...) {
        self.init(actions.compactMap {$0})
    }
    
    /// Creates a parallel action
    /// - Parameter actions: The nested actions that will be ran in parallel.
    public init (_ actions: [FiniteTimeAction]) {
        var maxDuration: Float = 0
        
        for action in actions {
            if action.duration > maxDuration {
                maxDuration = action.duration
            }
        }
        var adjustedActions: [FiniteTimeAction] = []
        for action in actions {
            let a: FiniteTimeAction
            let ad = action.duration
            if ad < maxDuration {
                a = SequenceAction ([action, DelayTime(duration: maxDuration-ad)])
            } else {
                a = action
            }
            adjustedActions.append(a)
        }
        self.actions = adjustedActions
        super.init(duration: maxDuration)
    }

    override func startAction(target: Entity) -> ActionState? {
        return ParallelState (action: self, target: target)
    }

    public override func reverse() -> FiniteTimeAction {
        var rev: [FiniteTimeAction] = []
        for action in actions {
            rev.append (action.reverse())
        }
        // I do not like this
        return Parallel (rev)
    }
}

class ParallelState: FiniteTimeActionState {
    let ap: Parallel
    var actionStates: [ActionState]
    
    init(action: Parallel, target: Entity) {
        ap = action
        actionStates = []
        for ia in action.actions {
            guard let state = ia.startAction(target: target) else { continue }
            actionStates.append (state)
        }
        super.init (action: action, target: target)
    }
    
    override func stop() {
        for astate in actionStates {
            astate.stop ()
        }
        super.stop()
    }
    
    override func update(time: Float) {
        for astate in actionStates {
            astate.update(time: time)
        }
    }
}
