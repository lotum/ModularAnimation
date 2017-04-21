/*
 Copyright (c) 2017 LOTUM GmbH
 Licensed under Apache License v2.0
 
 See https://github.com/LOTUM/ModularAnimation/blob/master/LICENSE for license information
 */

import Foundation

public enum AnimationAction {
    case _hide
    case _show
    case _fade(to: CGFloat, duration: TimeInterval)
    case _move(x: CGFloat, y: CGFloat, duration: TimeInterval)
    case _springMove(x: CGFloat, y: CGFloat, duration: TimeInterval)
    case _moveTo(x: CGFloat?, y: CGFloat?, duration: TimeInterval)
    case _springMoveTo(x: CGFloat?, y: CGFloat?, duration: TimeInterval)
    case _scale(x: CGFloat, y: CGFloat, duration: TimeInterval)
    case _springScale(x: CGFloat, y: CGFloat, duration: TimeInterval)
    case _transformBack(duration: TimeInterval)
    case _springTransformBack(duration: TimeInterval)
    case _delay(duration: TimeInterval)
    case _parallel(actions: [AnimationAction])
    case _serial(actions: [AnimationAction])
    
    public static func hide() -> AnimationAction {
        return ._hide
    }
    
    public static func show() -> AnimationAction {
        return ._show
    }
    
    public static func fade(to alpha: CGFloat, duration: TimeInterval = 0) -> AnimationAction {
        return ._fade(to: alpha, duration: duration)
    }
    
    public static func fadeOut(duration: TimeInterval = 0) -> AnimationAction {
        return ._fade(to: 0, duration: duration)
    }
    
    public static func fadeIn(duration: TimeInterval = 0) -> AnimationAction {
        return ._fade(to: 1, duration: duration)
    }
    
    public static func move(x: CGFloat = 0, y: CGFloat = 0, duration: TimeInterval = 0) -> AnimationAction {
        return ._move(x: x, y: y, duration: duration)
    }
    
    public static func springMove(x: CGFloat = 0, y: CGFloat = 0, duration: TimeInterval = 0) -> AnimationAction {
        return ._springMove(x: x, y: y, duration: duration)
    }
    
    public static func moveTo(x: CGFloat? = nil, y: CGFloat? = nil, duration: TimeInterval = 0) -> AnimationAction {
        return ._moveTo(x: x, y: y, duration: duration)
    }
    
    public static func springMoveTo(x: CGFloat? = nil, y: CGFloat? = nil, duration: TimeInterval = 0) -> AnimationAction {
        return ._springMoveTo(x: x, y: y, duration: duration)
    }
    
    public static func scale(x: CGFloat = 1, y: CGFloat = 1, duration: TimeInterval = 0) -> AnimationAction {
        return ._scale(x: x, y: y, duration: duration)
    }
    
    public static func scaleEqually(scale: CGFloat, duration: TimeInterval = 0) -> AnimationAction {
        return ._scale(x: scale, y: scale, duration: duration)
    }
    
    public static func springScale(x: CGFloat = 1, y: CGFloat = 1, duration: TimeInterval = 0) -> AnimationAction {
        return ._springScale(x: x, y: y, duration: duration)
    }
    
    public static func springScaleEqually(scale: CGFloat, duration: TimeInterval = 0) -> AnimationAction {
        return ._springScale(x: scale, y: scale, duration: duration)
    }
    
    public static func transformBack(duration: TimeInterval = 0) -> AnimationAction {
        return ._transformBack(duration: duration)
    }
    
    public static func springTransformBack(duration: TimeInterval = 0) -> AnimationAction {
        return ._springTransformBack(duration: duration)
    }
    
    public static func delay(duration: TimeInterval) -> AnimationAction {
        return ._delay(duration: duration)
    }
    
    public static func parallel(_ actions: AnimationAction...) -> AnimationAction {
        return ._parallel(actions: actions)
    }
    
    public static func serial(_ actions: AnimationAction...) -> AnimationAction {
        return ._serial(actions: actions)
    }
    
}

public extension UIView {
    public func serialAnimation(_ actions: AnimationAction...) -> AnimationModule {
        return animation(._serial(actions: actions))
    }
    
    public func parallelAnimation(_ actions: AnimationAction...) -> AnimationModule {
        return animation(._parallel(actions: actions))
    }
    
    public func animation(_ action: AnimationAction) -> AnimationModule {
        switch(action) {
        case ._hide:
            return BasicAnimationModule(duration: 0) {
                self.isHidden = true
            }
            
        case ._show:
            return BasicAnimationModule(duration: 0) {
                self.isHidden = false
            }
            
        case ._fade(let to, let duration):
            return BasicAnimationModule(duration: duration) {
                self.alpha = to
            }
            
        case ._move(let x, let y, let duration):
            return BasicAnimationModule(duration: duration) {
                self.center.x += x
                self.center.y += y
            }
            
        case ._springMove(let x, let y, let duration):
            return SpringAnimationModule(duration: duration) {
                self.center.x += x
                self.center.y += y
            }
            
        case ._moveTo(let x, let y, let duration):
            return BasicAnimationModule(duration: duration) {
                if let x = x {
                    self.center.x = x
                }
                if let y = y {
                    self.center.y = y
                }
            }
            
        case ._springMoveTo(let x, let y, let duration):
            return SpringAnimationModule(duration: duration) {
                if let x = x {
                    self.center.x = x
                }
                if let y = y {
                    self.center.y = y
                }
            }
            
        case ._scale(let x, let y, let duration):
            return BasicAnimationModule(duration: duration) {
                self.transform = self.transform.scaledBy(x: x, y: y)
            }
            
        case ._springScale(let x, let y, let duration):
            return SpringAnimationModule(duration: duration) {
                self.transform = self.transform.scaledBy(x: x, y: y)
            }
            
        case ._transformBack(let duration):
            return BasicAnimationModule(duration: duration) {
                self.transform = .identity
            }
            
        case ._springTransformBack(let duration):
            return SpringAnimationModule(duration: duration) {
                self.transform = .identity
            }
            
        //TODO: nicer solution for this workaround (if animation does not affect anything, it is not executed at all)
        case ._delay(let duration):
            let originalAlpha = alpha
            let fadeABit = animation(.fade(to: alpha + 0.0001, duration: duration))
            let fadeBack = animation(.fade(to: originalAlpha, duration: 0))
            return SerialAnimation(fadeABit, fadeBack)
            
        case ._parallel(let actions):
            let parallel = ParallelAnimation()
            for action in actions {
                parallel.add(animation(action))
            }
            return parallel
            
        case ._serial(let actions):
            let serial = SerialAnimation()
            for action in actions {
                serial.append(animation(action))
            }
            return serial
        }
    }
}
