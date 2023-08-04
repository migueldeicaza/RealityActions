//
//  AmplitudeAction.swift
//  
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

class AmplitudeAction: FiniteTimeAction
{
    public var amplitude: Float = 0
}

class AmplitudeActionState: FiniteTimeActionState {
    var amplitude: Float
    var amplitudeRate: Float
    
    init (action: AmplitudeAction, target: Entity) {
        amplitude = action.amplitude
        amplitudeRate = 1
        super.init(action: action, target: target)
    }
}
