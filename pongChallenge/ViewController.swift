//
//  ViewController.swift
//  pongChallenge
//
//  Created by Ian W. Howe on 4/18/16.
//  Copyright © 2016 Ian W. Howe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var ball = UIView()
    var paddle = UIView()
    var botPaddle = UIView()
    var dynamicAnimator = UIDynamicAnimator()
    var playerOneStart = true
    var firstServe = true
    var singleServeMode = false
    var scoreBoardOne = UILabel()
    var scoreBoardTwo = UILabel()
    var scoreOne = 0
    var scoreTwo = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        //Configure scoreboard
        scoreBoardOne.text = "0"
        scoreBoardOne.alpha = 0.5
        scoreBoardOne.textColor = UIColor.redColor()
        scoreBoardOne.frame = CGRectMake(view.center.x - 30, view.center.y, 25, 35)
        view.addSubview(scoreBoardOne)
        
        scoreBoardTwo.text = "0"
        scoreBoardTwo.alpha = 0.5
        scoreBoardTwo.textColor = UIColor.blueColor()
        scoreBoardTwo.frame = CGRectMake(view.center.x + 30, view.center.y, 25, 35)
        view.addSubview(scoreBoardTwo)

        
        
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
        resetAnimator()
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
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        print(p)
        
        if p.y < 10 {
            scoreOne += 1
            scoreBoardOne.text = "\(scoreOne)"
        }
        else if p.y > view.frame.height - 10 {
            scoreTwo += 1
            scoreBoardTwo.text = "\(scoreTwo)"
        }
        
        if p.y < 10 || p.y > view.frame.height - 10 {
            if abs(scoreOne - scoreTwo) >= 2 && scoreOne >= 11 || scoreTwo >= 11 {
                if scoreOne > scoreTwo {
                    announceVictor(0)
                }
                else {
                    announceVictor(1)
                }
            }
            if scoreOne == 10 && scoreTwo == 10 {
                singleServeMode = true
            }
            if !firstServe || singleServeMode{
                playerOneStart = !playerOneStart
            }
            firstServe = !firstServe
            resetAnimator()
        }
        
    }
    
    func resetAnimator() {
        dynamicAnimator.removeAllBehaviors()
        ball.center = CGPoint(x: view.center.x , y: view.center.y)
        
        //Create dynamic behavior for the ball
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.density = 1.0
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 1.0
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        //Create a push behavior for the ball
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "launchBall", userInfo: nil, repeats: false)
        
        //Create collision behaviors so ball can collide w/ other objects
        let collisionBehavior = UICollisionBehavior(items: [ball, paddle, botPaddle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        //create dynamic animator for paddle
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle, botPaddle])
        paddleDynamicBehavior.density = 10000
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
    }
    
    func launchBall() {
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
            //xVector = -1 * xVector
        }
        pushBehavior.pushDirection = CGVectorMake(CGFloat(xVector), CGFloat(yVector))
        
        pushBehavior.magnitude = 0.25
        dynamicAnimator.addBehavior(pushBehavior)
    }
    
    func announceVictor(player: Int) {
        
    }
    

}

