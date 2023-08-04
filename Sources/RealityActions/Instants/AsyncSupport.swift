//
//  AsyncSupport.swift
//  
//
//  Created by Miguel de Icaza on 8/3/23.
//

import Foundation
import RealityKit

/// An action that invokes the calling continuation
class AsyncSupport: ActionInstant {
    var cc: CheckedContinuation<Void,Never>?
    public init (cc: CheckedContinuation<Void,Never>) {
        self.cc = cc
    }
    
    override func startAction(target: Entity) -> ActionState? {
        AsyncSupportState (action: self, target: target)
    }
}

class AsyncSupportState: ActionInstantState {
    let aas: AsyncSupport
    
    init(action: AsyncSupport, target: Entity) {
        self.aas = action
        super.init(action: action, target: target)
    }
    
    override func update(time: Float) {
        if let cc = aas.cc {
            aas.cc = nil
            cc.resume()
        }
    }
    
    override func stop() {
        if let cc = aas.cc {
            aas.cc = nil
            cc.resume()
        }
    }
}

