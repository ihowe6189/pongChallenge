//
//  ViewController.swift
//  pongChallenge
//
//  Created by Ian W. Howe on 4/18/16.
//  Copyright © 2016 Ian W. Howe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var ball = UIView()
    var paddle = UIView()
    var botPaddle = UIView()
    var dynamicAnimator = UIDynamicAnimator()
    var playerOneStart = true
    var scoreBoardOne = UILabel()
    var scoreBoardTwo = UILabel()
    var scoreOne = 0
    var scoreTwo = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure scoreboard
        scoreBoardOne.alpha = 0.5
        scoreBoardOne.textColor = UIColor.redColor()
        scoreBoardOne.frame = CGRectMake(view.center.x - 30, view.center.y, 25, 35)
        view.addSubview(scoreBoardOne)
        
        //Add a black ball object to the view
        ball = UIView(frame: CGRectMake(view.center.x, view.center.y, 20, 20))
        ball.backgroundColor = UIColor.blackColor()
        ball.layer.cornerRadius = 10
        ball.clipsToBounds = true
        
        view.addSubview(ball)
        
        //Add a red paddle object to the view
        paddle = UIView(frame: CGRectMake(view.center.x , view.center.y * 1.7, 80, 20))
        paddle.layer.cornerRadius = 5
        paddle.clipsToBounds = true
        paddle.backgroundColor = UIColor.redColor()
        view.addSubview(paddle)
        
        //Add a blue paddle (AI) to the view
        botPaddle = UIView(frame: CGRectMake(view.center.x , view.center.y * 0.59, 80, 20))
        botPaddle.layer.cornerRadius = 5
        botPaddle.clipsToBounds = true
        botPaddle.backgroundColor = UIColor.blueColor()
        view.addSubview(botPaddle)
        
        //Initialize the dynamic aminator
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        //Create dynamic behavior for the ball
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 1.0
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        //Create a push behavior for the ball
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        var xVector = 0.0
        var yVector = 0.0
        while xVector == 0 || yVector == 0 {
            let rng = drand48()
            if rng > 0.2 {
                if xVector != 0 {
                    yVector = rng
                }
                else {
                    xVector = rng
                }
            }
        }
        if !playerOneStart {
            yVector = -1 * yVector
            xVector = -1 * xVector
        }
        pushBehavior.pushDirection = CGVectorMake(CGFloat(xVector), CGFloat(yVector))
        
        pushBehavior.magnitude = 0.25
        dynamicAnimator.addBehavior(pushBehavior)
        
        //Create collision behaviors so ball can collide w/ other objects
        let collisionBehavior = UICollisionBehavior(items: [ball, paddle, botPaddle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        dynamicAnimator.addBehavior(collisionBehavior)
        
        //create dynamic animator for paddle
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle, botPaddle])
        paddleDynamicBehavior.density = 10000
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
        let panGesture = sender.locationInView(view)
        paddle.center = CGPointMake(panGesture.x, paddle.center.y)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    
    
    

}

