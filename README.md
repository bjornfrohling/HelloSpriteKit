#HelloSpriteKit
####An intro to Sprite Kit
*HelsinkiOS  07.05.15*
<Enter>

###1. Initial Sprite Kit Project
* UIViewController's view (SKView) works as container
* SKView will render the active Scene

###2. Scene
* Organise content of the game
e.g. Game level, Game menu
* Transition is happening from one Scene to another Scene
* !Anchor Point of a Scene is bottom, left!

###3. Node
* Element that is added to a Scene
* Has own content, size, position
* Nodes can have Child Nodes
e.g. Spaceship node ==> Gun node
* !Anchor Point of a Node is the centre!
* The Node's position is set in the Scene's coordinate system
* Games are made of Scenes. Scenes are made of Nodes

###4. Action
* Describe changes of Nodes
e.g. animate, fade, move, scale, rotate
* Scenes perform the Actions
* Execution in group or sequence possible
* Completion block available

###5. Physics
* Every Scene provides physics (SKPhysicsWorld)
* The shape of the PhysicsBody has to be defined

####Volume-based Physics Body
* Used when a Node is taking up space in a Scene
* Nodes will get mass and density as well as forces can be applied to them

####Edge-based Physics Body
* Just a invisible boundary
* Does not have volume or mass
e.g. adding boundaries to a Scene

####Dynamic volume-based body
* Object can be moved by the physics simulation and is affected by collisions
* Body will have properties like Restitution, Linear Damping etc

####Static volume-based body
* Object that will not be moved or affected by the physics simulations

####Collision
* Prevent objects from intersecting 

####Contact
* Notification when two objects have touched
* SKPyhsicsContactProtokol

###6. Sounds
* Core Audio Format (caf)
* Scene will play back sound files via SKAction

###7. Texture Atlases
* Group multiple smaller images into one larger image
* Graphic Engine will perform OpenGL draw call per texture atlas sheet instead for every single Sprite

###8. Rendering Loop
####For each frame:

1. Evaluate actions
2. Simulate physics
3. Applies constraints
4. Render the scene

####Callbacks in SKScene
* -update:
* -didEvaluateActions
* -didSimulatePhysics
* -didApplyConstraints
* -didFinishUpdate


