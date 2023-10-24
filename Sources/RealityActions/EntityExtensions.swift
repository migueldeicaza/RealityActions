//
//  EntityExtensions.swift
//  
//
//  Created by Miguel de Icaza on 8/3/23.
//

import Foundation
import RealityKit

let globalActionManager: ActionManager = {
    ActionManager()
} ()

public extension Entity {
    /// Starts executing an action, does not wait for completion.
    func start (_ action: BaseAction) {
        globalActionManager.add(action: action, target: self)
    }
    
    /// Starts executing an action, does not wait for completion.
    func start (_ actions: FiniteTimeAction...) {
        switch actions.count {
        case 0:
            return
        case 1:
            globalActionManager.add (action: actions.first!, target: self)
        default:
            let seq = SequenceAction(actions)
            globalActionManager.add (action: seq, target: self)
        }
    }
    
    /// Invokes the action asynchronously, and returns control when the action finishes
    func run (_ action: FiniteTimeAction) async {
        await withCheckedContinuation { cc in
            let seq = SequenceAction(action, AsyncSupport (cc: cc))
            globalActionManager.add (action: seq, target: self)
        }
    }
    
    /// Invokes the actions asynchronously, and returns control when the action finishes
    func run (_ actions: FiniteTimeAction...) async {
        if actions.count == 0 {
            return
        }
        await withCheckedContinuation { cc in
            if actions.count == 1 {
                let seq = SequenceAction(actions.first!, AsyncSupport (cc: cc))
                globalActionManager.add (action: seq, target: self)
            } else {
                let nested = SequenceAction(actions)
                let seq = SequenceAction(nested, AsyncSupport (cc: cc))
                globalActionManager.add (action: seq, target: self)
            }
        }
    }

    /// Removes a specific action from the entity
    func remove (action: BaseAction) {
        globalActionManager.remove(action: action, target: self)
    }
    
    /// Removes all the actions applied to this entity
    func removeAllActions () {
        globalActionManager.removeAllActions(forTarget: self)
    }
    
    /// Pauses all the actions on this entity
    func pauseActions () {
        globalActionManager.pause(target: self)
    }
    
    /// Resumes execution of all the actions on this entity that had previously been paused by ``pauseActions()``
    func resumeActions () {
        globalActionManager.resume(target: self)
    }
}

