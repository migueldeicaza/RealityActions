//
//  SplineMath.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation

/// CatmullRom Spline formula:
/// See http://en.wikipedia.org/wiki/Cubic_Hermite_spline#Cardinal_spline
/// - Parameter p0: Control point 1
/// - Parameter p1: Control point 2
/// - Parameter p2: Control point 3
/// - Parameter p3: Control point 4
/// - Parameter tension: The parameter c is a tension parameter that must be in the interval (0,1). In some sense, this can be interpreted as the "length" of the tangent. c=1 will yield all zero tangents, and c=0 yields a CatmullñRom spline.
/// - Parameter t: Time along the spline
/// - Returns: The point along the spline for the given time (t)
func cardinalSplineAt(p0: SIMD2<Float>, p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, tension _tension: Float, t: Float) -> SIMD2<Float>
{
    var tension = _tension
    if tension < 0 {
        tension = 0
    } else if tension > 1 {
        tension = 1
    }
    let t2 = t * t
    let t3 = t2 * t
    
    /*
     * Formula: s(-ttt + 2tt - t)P1 + s(-ttt + tt)P2 + (2ttt - 3tt + 1)P2 + s(ttt - 2tt + t)P3 + (-2ttt + 3tt)P3 + s(ttt - tt)P4
     */
    let s: Float = (1 - tension) / 2
    let b1: Float = s * ((-t3 + (2 * t2)) - t) // s(-t3 + 2 t2 - t)P1
    let b2: Float = s * (-t3 + t2) + (2 * t3 - 3 * t2 + 1) // s(-t3 + t2)P2 + (2 t3 - 3 t2 + 1)P2
    let b3: Float = s * (t3 - 2 * t2 + t) + (-2 * t3 + 3 * t2) // s(t3 - 2 t2 + t)P3 + (-2 t3 + 3 t2)P3
    let b4: Float = s * (t3 - t2) // s(t3 - t2)P4
    
    let x = (p0.x * b1 + p1.x * b2 + p2.x * b3 + p3.x * b4)
    let y = (p0.y * b1 + p1.y * b2 + p2.y * b3 + p3.y * b4)
    
    return [x, y]
}

// Bezier cubic formula:
//    ((1 - t) + t)3 = 1
// Expands to
//   (1 - t)3 + 3t(1-t)2 + 3t2(1 - t) + t3 = 1
func cubicBezier(a: Float, b: Float, c: Float, d: Float, t: Float) -> Float {
    let t1 = 1 - t
    return ((t1 * t1 * t1) * a + 3 * t * (t1 * t1) * b + 3 * (t * t) * (t1) * c + (t * t * t) * d)
}

func quadBezier(a: Float, b: Float, c: Float, t: Float) -> Float
{
    let t1 = 1 - t
    return (t1 * t1) * a + 2.0 * (t1) * t * b + (t * t) * c
}
