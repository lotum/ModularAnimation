/*
 Copyright (c) 2017 LOTUM GmbH
 Licensed under Apache License v2.0
 
 See https://github.com/LOTUM/ModularAnimation/blob/master/LICENSE for license information
 */

import Foundation
import UIKit

public protocol AnimationModule {
    typealias Block = () -> Void
    var duration: TimeInterval { get }
    
    func animationBlock(completion: Block?) -> Block?
    func play(completion: Block?)
}

extension AnimationModule {
    public func play(completion: Block? = nil) {
        let animation = animationBlock(completion: completion)
        animation?()
    }
}

public struct BasicAnimationModule: AnimationModule {
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let options: UIViewAnimationOptions
    public let animations: Block
    
    public init(duration: TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], animations: @escaping Block) {
        self.duration = duration
        self.animations = animations
        self.delay = delay
        self.options = options
    }
    
    public func animationBlock(completion: Block? = nil) -> Block? {
        return { _ in
            let completionWrapper: (Bool) -> Void = { _ in completion?() }
            UIView.animate(
                withDuration: self.duration,
                delay: self.delay,
                options: self.options,
                animations: self.animations,
                completion: completionWrapper
            )
        }
    }
}

public struct SpringAnimationModule: AnimationModule {
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let dampingRatio: CGFloat
    public let velocity: CGFloat
    public let options: UIViewAnimationOptions
    public let animations: Block
    
    public init(duration: TimeInterval, delay: TimeInterval = 0, dampingRatio: CGFloat = 0.8, velocity: CGFloat = 4, options: UIViewAnimationOptions = [], animations: @escaping Block) {
        self.duration = duration
        self.delay = delay
        self.dampingRatio = dampingRatio
        self.velocity = velocity
        self.options = options
        self.animations = animations
    }
    
    public func animationBlock(completion: Block? = nil) -> Block? {
        return { _ in
            let completionWrapper: (Bool) -> Void = { _ in completion?() }
            UIView.animate(
                withDuration: self.duration,
                delay: self.delay,
                usingSpringWithDamping: self.dampingRatio,
                initialSpringVelocity: self.velocity,
                options: self.options,
                animations: self.animations,
                completion: completionWrapper
            )
        }
    }
}

public class SerialAnimation: AnimationModule {
    private var animationModules: [AnimationModule]
    
    public init() {
        animationModules = []
    }
    
    public convenience init(_ modules: AnimationModule...) {
        self.init()
        animationModules.append(contentsOf: modules)
    }
    
    public func append(_ animationModule: AnimationModule) {
        animationModules.append(animationModule)
    }
    
    public var duration: TimeInterval {
        let durationSum = animationModules.reduce(0, {$0 + $1.duration})
        return durationSum
    }
    
    public func animationBlock(completion: Block? = nil) -> Block? {
        var animations: [Block?] = [completion]
        for (index, animationModule) in animationModules.reversed().enumerated() {
            let completion = animations[index]
            let animation = animationModule.animationBlock(completion: completion)
            animations.append(animation)
        }
        
        return animations.last!
    }
}

public class ParallelAnimation: AnimationModule {
    private var animationModules: [AnimationModule]
    
    public init() {
        animationModules = []
    }
    
    public convenience init(_ modules: AnimationModule...) {
        self.init()
        animationModules.append(contentsOf: modules)
    }
    
    public func add(_ animationModule: AnimationModule) {
        animationModules.append(animationModule)
    }
    
    public var duration: TimeInterval {
        let longestDuration = animationModules.reduce(0, {max($0, $1.duration)})
        return longestDuration
    }
    
    public func animationBlock(completion: Block? = nil) -> Block? {
        if animationModules.isEmpty {
            return completion
        }
        
        // return a function which plays all animations at once and passes the completion to longest
        return { _ in
            let longestDuration = self.duration
            var completionUsed = false // in case of multiple animations with same duration
            for animationModule in self.animationModules {
                if !completionUsed && animationModule.duration == longestDuration {
                    animationModule.play(completion: completion)
                    completionUsed = true
                } else {
                    animationModule.play()
                }
            }
        }
    }
}
