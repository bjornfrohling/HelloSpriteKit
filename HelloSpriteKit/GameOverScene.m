//
//  GameOverScene.m
//  HelloSpriteKit
//
//  Created by Björn Fröhling on 06/05/15.
//  Copyright (c) 2015 Björn Fröhling. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene

static const CGFloat kTransitionDuration = 1.0;

- (id)initWithSize:(CGSize)size {
    
    self = [super initWithSize:size];
    
    if (self) {
        self.backgroundColor = [SKColor blackColor];

        // Add titel label
        SKLabelNode *titelLabel = [SKLabelNode labelNodeWithText:@"GAME OVER :("];
        titelLabel.fontColor = [SKColor whiteColor];
        titelLabel.fontSize = 44.0;
        titelLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:titelLabel];
        
        // Add description label
        SKLabelNode *descriptionLabel = [SKLabelNode labelNodeWithText:@"Tap to re-start"];
        descriptionLabel.fontColor = [SKColor whiteColor];
        descriptionLabel.fontSize = 24.0;
        descriptionLabel.position = CGPointMake(size.width/2, titelLabel.position.y - titelLabel.frame.size.height);
        
        [self addChild:descriptionLabel];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    GameScene *gameScene = [GameScene sceneWithSize:self.size];
    [self.view presentScene:gameScene transition:[SKTransition doorsOpenHorizontalWithDuration:kTransitionDuration]];
}

@end
