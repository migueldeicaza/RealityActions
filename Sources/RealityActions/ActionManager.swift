//
//  ActionManager.swift
//  
//
//  Created by Miguel de Icaza on 8/3/23.
//

import Foundation
import RealityKit

public class ActionManagerSystem : System {
    public required init(scene: Scene) {
    }


    public func update(context: SceneUpdateContext) {
        globalActionManager.update(dt: Float (context.deltaTime))
    }
}

/// This class manages the running actions.
/// Actions are started from the extension methods on the Entity to start actions.
public class ActionManager {
    class HashElement {
        var actionIndex: Int = 0
        var actionStates: [ActionState] = []
        var currentActionState: ActionState?
        var currentActionSalvaged: Bool = false
        var paused: Bool
        var target: Entity
        
        init (target: Entity, paused: Bool) {
            self.target = target
            self.paused = paused
        }
    }
    
    var targets: [Entity:HashElement] = [:]
    
    var currentTargetSalvaged: Bool = false
    var _currentTarget: HashElement?
    var targetsAvailable = false

    deinit {
        removeAllActions ()
    }
    
    /// Returns the action matching the tag assigned to that entity
    /// - Parameters:
    ///   - tag: Tag to lookup
    ///   - target: The target to lookup
    /// - Returns: The action with the specified tag running on the specified target
    public func getAction(tag: Int?, target: Entity) -> BaseAction? {
        guard let element = targets [target] else { return nil }
        
        return element.actionStates.first { $0.action.tag == tag }?.action
    }
    
    /// Returns the internal action state
    /// - Parameters:
    ///   - tag: Tag to lookup
    ///   - target: The target to lookup
    /// - Returns: The internal action state with the specified tag running on the specified target
    public func getActionState (tag: Int?, target: Entity) -> AnyObject? {
        guard let element = targets [target] else { return nil }
        
        return element.actionStates.first { $0.action.tag == tag }
    }
    
    /// Returns the number of running actions for the specified target
    public func numberOfRunningActions (target: Entity) -> Int {
        guard let element = targets [target] else { return 0 }
        return element.actionStates.count
    }
    
    public func update(dt: Float) {
        guard targetsAvailable else { return }
        
        let keys = targets.keys
        for target in keys {
            guard let currentTarget = targets [target] else { continue }

            // Sets the global
            _currentTarget = currentTarget
            currentTargetSalvaged = false
            
            if !currentTarget.paused {
                // The 'actions' may change while inside this loop.
                currentTarget.actionIndex = 0
                while currentTarget.actionIndex < currentTarget.actionStates.count {
                    defer { currentTarget.actionIndex += 1 }
                    currentTarget.currentActionState = currentTarget.actionStates [currentTarget.actionIndex]
                    if currentTarget.currentActionState == nil {
                        continue
                    }
                    
                    currentTarget.currentActionSalvaged = false
                    currentTarget.currentActionState?.step(dt: dt)
                    
                    if currentTarget.currentActionSalvaged {
                        // The currentAction told the node to remove it. To prevent the action from
                        // aidentally deallocating itself before finishing its step, we retained
                        // it. Now that step is done, it's safe to release it.
                        
                        //currentTarget->currentAction->release();
                    } else if let cas = currentTarget.currentActionState, cas.isDone {
                        cas.stop()
                        
                        // Make currentAction nil to prevent removeAction from salvaging it.
                        currentTarget.currentActionState = nil
                        removeAction (actionState: cas)
                    }
                    currentTarget.currentActionState = nil
                }
            }
            
            // only delete currentTarget if no actions were scheduled during the cycle (issue #481)
            if currentTargetSalvaged && currentTarget.actionStates.count == 0 {
                delete(hashElement: currentTarget)
            }
        }
        
        _currentTarget = nil
    }
    
    func delete (hashElement: HashElement) {
        hashElement.actionStates = []
        targets.removeValue(forKey: hashElement.target)
        targetsAvailable = targets.count > 0
    }
        
    /// Pauses any actions on the specified entity
    public func pause (target: Entity) {
        if let element = targets [target] {
            element.paused = true
        }
    }
    
    /// Resumes the actions on the specified entity/
    public func resume (target: Entity){
        if let element = targets [target] {
            element.paused = false
        }
    }
    
    /// Pauses all the running actions, and returns an array of the affected entities.
    public func pauseAllRunningActions() -> [Entity] {
        var idsWithActions: [Entity] = []
        
        for element in targets.values {
            if !element.paused {
                element.paused = true
                idsWithActions.append(element.target)
            }
        }
        
        return idsWithActions
    }
    
    /// Resumes the actions on the specified entities
    public func resume (targets: [Entity]) {
        targets.forEach { resume (target: $0) }
    }
    
    public func cancelActiveActions() {
        fatalError("TODO")
//        for target in targets {
//            var tcs = target.Value.ActionStates.LastOrDefault();
//            TaskSourceState taskSourceState = tcs as TaskSourceState;
//            if (taskSourceState != null)
//            {
//                taskSourceState.Cancel();
//                continue;
//            }
//            var seqState = tcs as SequenceState;
//            seqState?.Cancel();
//        }
    }
    
    @discardableResult
    public func add (action: BaseAction, target: Entity, paused: Bool = false) -> AnyObject? {
        func getElement (target: Entity) -> HashElement {
            guard let element = targets [target] else {
                let new = HashElement (target: target, paused: paused)
                targets [target] = new
                targetsAvailable = true
                return new
            }
            return element
        }
        let element = getElement (target: target)
        
        var isActionRunning = false
        for existingState in element.actionStates {
            if existingState.action === action {
                isActionRunning = true
                break
            }
        }
//        print ("Targets: \(targets.count)")
//        for x in targets.keys {
//            print ("   \(x.name) - ")
//        }
        assert (!isActionRunning, "Action is already running for this target.");
        guard let state = action.startAction(target: target) else { return nil }
        element.actionStates.append(state)
        return state
    }
    
    public func removeAllActions() {
        guard targetsAvailable else {
            return
        }

        for target in targets.keys {
            removeAllActions(forTarget: target)
        }
    }
    
    public func removeAllActions(forTarget target: Entity) {
        guard let element = targets [target] else { return }

        if element.actionStates.contains(where: { $0 === element.currentActionState }) && !element.currentActionSalvaged {
            element.currentActionSalvaged = true
        }
        
        element.actionStates = []
        
        if _currentTarget === element {
            currentTargetSalvaged = true
        } else {
            delete(hashElement: element)
        }
    }
    
    func removeAction (actionState: ActionState?) {
        guard let actionState else { return }
        guard let target = actionState.originalTarget else { return }
        guard let element = targets [target] else { return }
        
        guard let idx = element.actionStates.firstIndex (where: { $0 === actionState }) else { return }
        removeAction(atIndex: idx, element: element)
    }
    
    func removeAction(atIndex index: Int, element: HashElement)
    {
        let action = element.actionStates [index]
        
        if action === element.currentActionState && (!element.currentActionSalvaged) {
            element.currentActionSalvaged = true
        }
        
        element.actionStates.remove(at: index)
        
        // update actionIndex in case we are in tick. looping over the actions
        if element.actionIndex >= index {
            element.actionIndex -= 1
        }
        
        if element.actionStates.count == 0 {
            if _currentTarget === element {
                currentTargetSalvaged = true
            } else {
                delete(hashElement: element)
            }
        }
    }
    
    func remove (action: BaseAction, target: Entity) {
        guard let element = targets [target] else { return }
        let limit = element.actionStates.count
        
        for i in 0..<limit {
            let actionState = element.actionStates[i]
            
            if actionState.action === action && actionState.originalTarget == target {
                removeAction(atIndex: i, element: element)
                break;
            }
        }

    }
    
    /// Removes an action by tag from the specified entity.
    public func removeAction (tag: Int?, target: Entity) {
        // Early out if we do not have any targets to search
        guard targets.count != 0 else { return }
        guard let element = targets [target] else { return }
        
        let limit = element.actionStates.count
        
        for i in 0..<limit {
            let actionState = element.actionStates[i]
            
            if actionState.action.tag == tag && actionState.originalTarget == target {
                removeAction (atIndex: i, element: element)
                break;
            }
        }
    }
}
    
