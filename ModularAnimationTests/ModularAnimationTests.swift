/*
 Copyright (c) 2017 LOTUM GmbH
 Licensed under Apache License v2.0
 
 See https://github.com/LOTUM/ModularAnimation/blob/master/LICENSE for license information
 */

import XCTest
@testable import ModularAnimation

class ModularAnimationTests: XCTestCase {
    
    func testSerialAnimationDuration() {
        let animation1 = FakeAnimationModule(duration: 1)
        let animation2 = FakeAnimationModule(duration: 2)
        
        let serial = SerialAnimation()
        XCTAssertEqual(serial.duration, 0)
        
        serial.append(animation1)
        XCTAssertEqual(serial.duration, 1)
        
        serial.append(animation2)
        XCTAssertEqual(serial.duration, 3)
    }
    
    func testParallelAnimationDuration() {
        let animation1 = FakeAnimationModule(duration: 1)
        let animation2 = FakeAnimationModule(duration: 2)
        let animation3 = FakeAnimationModule(duration: 1.5)
        
        let parallel = ParallelAnimation()
        XCTAssertEqual(parallel.duration, 0)
        
        parallel.add(animation1)
        XCTAssertEqual(parallel.duration, 1)
        
        parallel.add(animation2)
        XCTAssertEqual(parallel.duration, 2)
        
        parallel.add(animation3)
        XCTAssertEqual(parallel.duration, 2)
    }
    
    func testSerialAnimationAnimationBlock() {
        var results: [Int] = []
        let animation1 = FakeAnimationModule(duration: 0, block: {results.append(1)})
        let animation2 = FakeAnimationModule(duration: 0, block: {results.append(2)})
        let animation3 = FakeAnimationModule(duration: 0, block: {results.append(3)})
        let completion: AnimationModule.Block = {results.append(4)}
        
        let serial = SerialAnimation(animation1, animation2, animation3)
        let animationBlock = serial.animationBlock(completion: completion)
        animationBlock!()
        
        XCTAssertEqual(results, [1, 2, 3, 4])
    }
    
    func testParallelAnimationAnimationBlock() {
        var results: [Int] = []
        let animation1 = FakeAnimationModule(duration: 1, block: {results.append(1)})
        let animation2 = FakeAnimationModule(duration: 2, block: {results.append(2)})
        let animation3 = FakeAnimationModule(duration: 1, block: {results.append(3)})
        let completion: AnimationModule.Block = {results.append(4)}
        
        let parallel = ParallelAnimation(animation1, animation2, animation3)
        let animationBlock = parallel.animationBlock(completion: completion)
        animationBlock!()
        
        XCTAssertEqual(results, [1, 2, 4, 3]) // completion is called after block with longest duration
    }
    
}
