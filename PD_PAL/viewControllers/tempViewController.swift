//
//  tempViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-11-15.
//  Copyright © 2019 WareOne. All rights reserved.
/*
 Revision History:
 <Date, Name, Changes made>
 <October 25, 2019, Spencer Lall, applied default page design>
 <November 5, 2019, Spencer Lall, Updated the default page design>
 <November 7, 2019, Spencer Lall, Added dynamic elements>
 <November 7, 2019, Spencer Lall, Created the Start, Stop, Complete button>
 <November 9, 2019, Spencer Lall, Added GIFs>
 <November 10, 2019, Spencer Lall, Made GIFs Asynchronous>
 <November 10, 2019, Arian Vafadar, Created the Skip button and updated the Start button>
 <November 11, 2019, Izyl Canonicato, Created and updated all of the button designs>
 <November 17, 2019, Spencer Lall, Fixed the memory leak issue>
 <November 28, 2019, Izyl Canonicato, Implemented the Timer>
 */
//

import UIKit

class tempViewController: UIViewController {
    
    /* IBOutlet Labels */
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var LoadingLabel: UILabel!
    @IBOutlet weak var SetsLabel: UILabel!
    @IBOutlet weak var DescriptionText: UILabel!

    /* IBOutlet Buttons */
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var nextSetButton: UIButton!
    
    /* global variables */
    var imageView = UIImageView()
    var exercise_name2: String!
    var seconds: Int = 0
    var timer = Timer()
    var isTimerRunning = false
    var setNumber: Int = 1
    var restInterval = 0
    
    // Animation stuff
    let shapelayer = CAShapeLayer()
    var progress: Float = 0
    
    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* skip segue updates global variables to reload page with next excercise */
        if segue.identifier == "SkipSegue" {
            if Global.routine_index < 0 { Global.routine_index = 0 }
            let vc = segue.destination as! ExerciseViewController
            Global.next_routine_exercise = Global.routine_data[Global.routine_index + 1]
            Global.routine_index += 1
        }
    }
    
    /* put code that depends on IsRoutineExercise flag in here */
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print ("log: tempViewController")
            
            if Global.next_routine_exercise != "" { self.exercise_name2 = Global.next_routine_exercise }
            Global.next_routine_exercise = ""
            
            /* navigation bar stuff */
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.title = nil
            let homeButton = UIButton(type: .custom)
            homeButton.applyHomeButton()
            homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: homeButton)
            self.navigationItem.rightBarButtonItem  = barButton
            
            /* populate exercise description */
            let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name2 ?? "nil")
            self.show_exercise_description(string: readResult.Description, DLabel: DescriptionLabel, DText: DescriptionText)
            
            /* page message */
            self.show_page_message(s1: exercise_name2 ?? "Unable to retrieve exercise name", s2: exercise_name2 ?? "nil")
            
            /* dynamic elements */
            //-> stop button
            stopButton.applyDefaultTimerButtonFrame()
            stopButton.timerButtonDesign()
            stopButton.setTitle("STOP", for: .normal)
            stopButton.backgroundColor = Global.color_schemes.m_lightRed
            
            //-> completed Button
            completedButton.applyRightTimerButtonFrame()
            completedButton.timerButtonDesign()
            completedButton.setTitle("NEXT EXERCISE", for: .normal)
            completedButton.backgroundColor = Global.color_schemes.m_blue2
            
            //-> timer label
            timerLabel.timerAndSetsDesign()
            timerLabel.applyTimerLabelFrame()
            
            //-> sets label
            SetsLabel.timerAndSetsDesign()
            SetsLabel.applySetsLabelFrame()
            SetsLabel.text = "SET " + "\(self.setNumber)"
            
            //-> Skip button
            skipButton.applyLeftTimerButtonFrame()
            skipButton.timerButtonDesign()
            skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            skipButton.setTitle("SKIP",for: .normal)
            skipButton.backgroundColor = Global.color_schemes.m_lightGreen
            
            //-> start button
            startButton.applyRightTimerButtonFrame()
            startButton.timerButtonDesign()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            
            //-> next set button
            nextSetButton.applyLeftTimerButtonFrame()
            nextSetButton.timerButtonDesign()
            nextSetButton.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
            nextSetButton.setTitle("NEXT SET", for: .normal)
            nextSetButton.backgroundColor = Global.color_schemes.m_lightGreen
            
            //-> timer animation
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: 285, y: 488), radius: 50, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            shapelayer.path = circularPath.cgPath
            shapelayer.strokeColor = Global.color_schemes.m_blue1.cgColor
            shapelayer.lineWidth = 10
            shapelayer.lineCap = CAShapeLayerLineCap.round
            shapelayer.fillColor = UIColor.clear.cgColor
            shapelayer.strokeEnd = 0
            view.layer.addSublayer(shapelayer)
            
            /* when entering this page, hide these elements */
            shapelayer.isHidden = true
            stopButton.isHidden = true
            timerLabel.isHidden = true
            SetsLabel.isHidden = true
            completedButton.isHidden = true

            DescriptionText.isHidden = false
            DescriptionLabel.isHidden = false
            startButton.isHidden = false
            skipButton.isHidden = false
            LoadingLabel.isHidden = false
            
            /* last exercise */
            if Global.routine_index == 2 { skipButton.isHidden = true }
        }
        
        /* put code that does not depends on IsRoutineExercise flag in here */
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = Global.color_schemes.m_bgColor  // background color
            logNavigationStack()
            
            /* when entering this page, hide these elements */
            shapelayer.isHidden = true
            stopButton.isHidden = true
            timerLabel.isHidden = true
            completedButton.isHidden = true
            SetsLabel.isHidden = true
            nextSetButton.isHidden = true
            
            /* when entering this page, show these elements */
            startButton.isHidden = false
            skipButton.isHidden = false
        }
    
    /* put slow code in here to run on a different thread */
    override func viewDidAppear(_ animated: Bool) {
        /* gif */
        do {
            let temp = global_ExerciseData.read_exercise(NameOfExercise: exercise_name2 ?? "nil")
            let gif = try UIImage(gifName: temp.Link)
            self.imageView.setGifImage(gif)
            imageView.frame = CGRect(x: 0, y: 112, width: 375, height: 300)
            view.addSubview(imageView)

        } catch { print(error) }
        
        LoadingLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /* back button is pressed */
        if self.isMovingFromParent {
            /* decrement routines exercise index */
            if Global.routine_index > 0 { Global.routine_index = Global.routine_index - 1 }
        }
    }
    
    /* when start button is tapped */
    @IBAction func startButton(_ sender: Any) {
        
        /* hide these elements */
        DescriptionLabel.isHidden = true
        DescriptionText.isHidden = true
        startButton.isHidden = true
        skipButton.isHidden = true
        
        /* show these elements */
        shapelayer.isHidden = false
        stopButton.isHidden = false
        timerLabel.isHidden = false
        SetsLabel.isHidden = false

        /* start timer */
        runTimer()
    }
    
    /* when stop button is tapped */
    @IBAction func stopButton(_ sender: Any) {
        
        /* reset timer value */
        timer.invalidate()
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name2 ?? "nil")
        seconds = data.Duration
        timerLabel.text = "\(seconds)"
        
        /* show these elements */
        DescriptionLabel.isHidden = false
        DescriptionText.isHidden = false
        startButton.isHidden = false
        skipButton.isHidden = false
        
        /* hide these elements */
        shapelayer.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        SetsLabel.isHidden = true
    }
    
    /* when home button on navigation bar is tapped */
    @objc func homeButtonTapped(sender: UIButton!) {
        killGif() /* kill running gif */
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    /* next set button is tapped  */
    @objc func nextSetButtonTapped(sender: UIButton!) {
        
        if self.setNumber == 1 {
            /* parse Date() function into year, month, day, and hour */
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            let hour = Calendar.current.component(.hour, from: Date())
            
            /* insert excercise as done */
            global_UserData.Add_Exercise_Done(ExerciseName: exercise_name2 ?? "nil", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
        }
        
        /* update set number variable */
        self.setNumber = self.setNumber + 1
        SetsLabel.text = "SET " + "\(self.setNumber)"
        self.progress = 0
        
        /* last set */
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name2 ?? "nil")
        if self.setNumber == readResult.Sets {
            completedButton.applyDefaultTimerButtonFrame()
        }
        
        /* hide these elements */
        completedButton.isHidden = true
        nextSetButton.isHidden = true
        
        /* show these elements */
        shapelayer.isHidden = false
        timerLabel.isHidden = false
        SetsLabel.isHidden = false
        stopButton.isHidden = false
        
        /* reset timer */
        timer.invalidate()
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name2 ?? "nil")
        seconds = data.Duration
        self.restInterval = 0
        runTimer()
    }
    
    /* skip button is tapped */
    @objc func skipButtonTapped() {
        killGif() /* kill running gif */
    }
    
    /* when completed button is tapped */
    @IBAction func completedButton(_ sender: Any) {
        
        if self.setNumber == 1 {
            /* parse Date() function into year, month, day, and hour */
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            let hour = Calendar.current.component(.hour, from: Date())
            
            /* insert excercise as done */
            global_UserData.Add_Exercise_Done(ExerciseName: exercise_name2 ?? "nil", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
        }
        
        killGif() /* kill running gif */
        
        /* last excercise */
        if Global.routine_index == 2 {
            
            completedButton.setTitle("EXIT", for: .normal)
            
            /* navigate to home page */
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
            self.present(newViewController, animated: true, completion: nil)
            
            /* reset routine index */
            Global.routine_index = 0
        }
    }
        
    /* when home button on navigation bar is tapped */
//    @objc func homeButtonTapped(sender: UIButton!) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
//        self.present(newViewController, animated: true, completion: nil)
//    }
    
    /* starts timer */
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name2 ?? "nil")
        seconds = data.Duration
    }
    
    /* decrements timer */
    @objc func updateTimer() {
        if restInterval == 0 {
            seconds -= 1
            timerLabel.text = "\(seconds)" + "s"
        } else {
            seconds += 1
            timerLabel.text = "REST: " + "\(seconds)" + "s"
        }
        
        /* Animate circular progress */
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = progress
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name2 ?? "nil")
        let maxTime = data.Duration
        progress += 1/Float(maxTime)
        basicAnimation.toValue = progress
        shapelayer.strokeEnd = CGFloat(progress)
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shapelayer.add(basicAnimation, forKey: "Update")
        
        /* when countdown is done */
        if seconds <= 0 {
            stopButton.isHidden = true
            completedButton.isHidden = false
            nextSetButton.isHidden = false
            shapelayer.isHidden = true
            
            SetsLabel.text = "SET " + "\(self.setNumber)" + " FINISHED!"
            self.restInterval = 1
            
            /* last set */
            let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name2 ?? "nil")
            if self.setNumber == readResult.Sets { nextSetButton.isHidden = true }
        }
    }
    
    /* kills running gifs */
    func killGif() {
        self.imageView.removeFromSuperview()
        self.imageView = UIImageView()
    }
}
