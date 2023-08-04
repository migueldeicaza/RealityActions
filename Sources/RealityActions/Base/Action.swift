//
//  Action.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Base class for all the actions in RealityAction
///
/// Actions are stateless, when you subclass this class, you should never keep any writable state here, the class
/// is merely a blueprint for what the class will do.
public class BaseAction
{
    public var tag: Int?
    
    internal func startAction (target: Entity) -> ActionState? {
        nil
    }
}

class ActionState {
    /// Gets or sets the target.
    ///
    /// Will be set with the 'StartAction' method of the corresponding Action.
    /// When the 'Stop' method is called, Target will be set to null.
    var target: Entity?
    var originalTarget: Entity?
    var action: BaseAction
    
    init (action: BaseAction, target: Entity) {
        self.action = action
        self.target = target
        self.originalTarget = target
    }
    
    /// <summary>
    /// Gets a value indicating whether this instance is done.
    /// </summary>
    /// <value><c>true</c> if this instance is done; otherwise, <c>false</c>.</value>
    var isDone: Bool { true }

    /// Called after the action has finished.
    /// It will set the 'target' to nil
    func stop() {
        target = nil
    }
    
    /// Called every frame with it's delta time.
    /// - Parameter dt: Delta time
    func step (dt: Float) {
        
    }
    
    /// Called once per frame.
    /// - Parameter time: A value between 0 and 1; 0 means that the action just started, 0.5 means the action is in the middle; 1 means the action is over
    ///
    func update (time: Float) {
        
    }
}

