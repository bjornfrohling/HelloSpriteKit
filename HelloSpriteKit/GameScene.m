//
//  GameScene.m
//  HelloSpriteKit
//
//  Created by Björn Fröhling on 06/05/15.
//  Copyright (c) 2015 Björn Fröhling. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"


@interface GameScene ()

@property (nonatomic) SKSpriteNode *paddle;

@end

#pragma mark -
#pragma mark Constants

/* Categories will be asigned to a body to distinguish them in case of contact */
static const uint32_t kBallBodyCategory       = 0x1;       // 00000000000000000000000000000001
static const uint32_t kBrickBodyCategory      = 0x1 << 1;  // 00000000000000000000000000000010
static const uint32_t kBottomEdgeBodyCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t kPaddleBodyCategory     = 0x1 << 3;  // 00000000000000000000000000001000

static const CGFloat kTransitionDuration = 1.0;
static const CGFloat kPaddleYPosition    = 100.0;
static const NSInteger kNumberOfBricks   = 4;

#pragma mark -

@implementation GameScene

-(void)didMoveToView:(SKView *)presentingView {
    
    /* Setup your scene here */
    self.backgroundColor = [SKColor whiteColor];
    
    // Add an edge-based physics body to the scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    // Disable gravity of the physics world
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    self.physicsWorld.contactDelegate = self;
    
    // Set up the game UI
    [self addBall];
    [self addPaddle];
    [self addBricks];
    [self addBottomEdge];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        CGPoint touchLocation = [touch locationInNode:self];
        
        CGPoint nextPaddlePosition = CGPointMake(touchLocation.x, 100);
        
        CGFloat halfOfPaddleWidth = self.paddle.size.width/2;
        // Limit the paddle movement respective to left and right scene bounderies
        if (nextPaddlePosition.x < halfOfPaddleWidth) {
            nextPaddlePosition.x = halfOfPaddleWidth;
        }
        if (nextPaddlePosition.x > self.size.width - halfOfPaddleWidth) {
            nextPaddlePosition.x = self.size.width - halfOfPaddleWidth;
        }
        
        self.paddle.position = nextPaddlePosition;
    }
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark -
#pragma mark private methods

- (void)addBall {
    // Create a new sprite node from an image
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    // Create a CGPoint for position
    CGSize size = self.scene.size;
    CGPoint ballPosition = CGPointMake(size.width/2, size.height/2);
    ball.position = ballPosition;
    
    // Add a physics body
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    
    // disable friction
    ball.physicsBody.friction = 0;
    
    // disable damping of the velocity
    ball.physicsBody.linearDamping = 0;
   
    // set full bounciness
    ball.physicsBody.restitution = 1.0f;
    
    // Asign the body category to be able to identify the body
    ball.physicsBody.categoryBitMask = kBallBodyCategory;
   
    // Add categories for getting notification when touching
    ball.physicsBody.contactTestBitMask = kBrickBodyCategory | kBottomEdgeBodyCategory;

    // Add the sprite node to the scene
    [self addChild:ball];
    
    // Create a vector, (xAxis, yAxis)
    CGVector impulseVector = CGVectorMake(10, 10);
    
    // No gravity, apply initial implulse to the ball
    [ball.physicsBody applyImpulse:impulseVector];
}

- (void)addPaddle {
    
    // Create paddle node
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    
    // Set initial paddle position in the scene
    self.paddle.position = CGPointMake(self.scene.size.width/2, kPaddleYPosition);
    
    // Asign a volume-based physics body with the size of the paddle
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    // Set to static physicsBody since the paddle should not be effected by collisions
    self.paddle.physicsBody.dynamic = NO;
    
    self.paddle.physicsBody.categoryBitMask = kPaddleBodyCategory;
    
    // Add the paddle node to the scene
    [self addChild:self.paddle];
}

- (void)addBricks {
    // Add four brick nodes to the scene
    for (int i = 0; i < kNumberOfBricks; i++) {
        SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        // Asign a volume-based physics vody with the size of a brick
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        // Static body
        brick.physicsBody.dynamic =  NO;
        // Asign the dedicated physics body category
        brick.physicsBody.categoryBitMask = kBrickBodyCategory;
        
        CGSize size = self.scene.size;
        int xPos = size.width / (kNumberOfBricks+1) * (i+1);
        int yPos = size.height - 50;
        brick.position = CGPointMake(xPos, yPos);
        
        // Add the brick node to the game scene
        [self addChild:brick];
    }
}

- (void)addBottomEdge {
    // Create node without visual content in order to
    SKNode *bottomEdgeNode = [SKNode node];
    
    // Add a physicsBody starting from left bottom corner to right bottom corner
    bottomEdgeNode.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(self.scene.size.width, 1)];
    // Asign dedicated body category
    bottomEdgeNode.physicsBody.categoryBitMask = kBottomEdgeBodyCategory;
    
    [self addChild:bottomEdgeNode];
}

#pragma mark -
#pragma mark SKPhysicsContactDelegate method

- (void)didBeginContact:(SKPhysicsContact *)contact {
    // Notification after two objects touchted
    SKPhysicsBody *notTheBallBody;
    
    // Check if bodyA is bodyB was the body of the ball node
    if (contact.bodyA.categoryBitMask == kBallBodyCategory) {
        notTheBallBody = contact.bodyB;
    }
    else if (contact.bodyB.categoryBitMask == kBallBodyCategory) {
        notTheBallBody = contact.bodyA;
    }
    
    if (notTheBallBody.categoryBitMask == kBrickBodyCategory) {
        // Ball had contact with a brick
        SKAction *playSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        [self runAction:playSFX];
        
        [notTheBallBody.node removeFromParent];
    }
    
    if (notTheBallBody.categoryBitMask == kBottomEdgeBodyCategory) {
        // Ball had contact with bottom of scene
        // Present GameOverScene
        GameOverScene *endScene = [GameOverScene sceneWithSize:self.size];
        [self.view presentScene:endScene transition:[SKTransition doorsCloseHorizontalWithDuration:kTransitionDuration]];
    }
}


@end
