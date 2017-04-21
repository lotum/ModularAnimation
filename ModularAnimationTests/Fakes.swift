/*
 Copyright (c) 2017 LOTUM GmbH
 Licensed under Apache License v2.0
 
 See https://github.com/LOTUM/ModularAnimation/blob/master/LICENSE for license information
 */

import ModularAnimation

struct FakeAnimationModule: AnimationModule {
    let duration: TimeInterval
    let block: Block?
    
    init(duration: TimeInterval, block: Block? = nil) {
        self.duration = duration
        self.block = block
    }
    
    func animationBlock(completion: Block?) -> Block? {
        return {
            self.block?()
            completion?()
        }
    }
}
