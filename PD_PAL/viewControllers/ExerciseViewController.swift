//
//  WallPushUpViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    /* IBOutlet Labels */
    @IBOutlet weak var DescriptionText: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    /* IBOutlet buttons */
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    /* global variables */
    var routine_data: [String]!
    var exercise_name: String!
    var exercise_number = 1

    // -> timer variables
    var seconds = 5            // get this value from db
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    /* when start button is tapped */
    @IBAction func startButton(_ sender: Any) {
        
        /* hide these elements */
        DescriptionLabel.isHidden = true
        DescriptionText.isHidden = true
        startButton.isHidden = true
        skipButton.isHidden = true
        
        /* show these elements */
        stopButton.isHidden = false
        timerLabel.isHidden = false
        
        /* start timer */
        runTimer()
    }
    
    /* when stop button is tapped */
    @IBAction func stopButton(_ sender: Any) {
        
        /* reset timer value */
        timer.invalidate()
        seconds = 5                         // reset value
        timerLabel.text = "\(seconds)"
        
        /* show these elements */
        DescriptionLabel.isHidden = false
        DescriptionText.isHidden = false
        startButton.isHidden = false
        skipButton.isHidden = false
        
        /* hide these elements */
        stopButton.isHidden = true
        timerLabel.isHidden = true
    }
    
    /* when completed button is tapped */
    @IBAction func completedButton(_ sender: Any) {
        
        /* parse Date() function into year, month, day, and hour */
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        
        /* insert excercise as done */
        global_UserData.Add_Exercise_Done(ExerciseName: exercise_name ?? "nil", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
    }
    
    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* use segue to forward pass exercise name to destination exercise view controller */
        if segue.identifier == "SkipSegue" {
            let vc = segue.destination as! tempViewController
            vc.exercise_name2 = (sender as! UIButton).titleLabel!.text!
        }
    }
    
    /* put code that depends on IsRoutineExercise flag in here */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Global.next_routine_exercise != "" { self.exercise_name = Global.next_routine_exercise }
        Global.next_routine_exercise = ""
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue1
        self.title = nil
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton
        
        /* populate exercise description */
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name ?? "nil")
        self.show_exercise_description(string: readResult.Description, DLabel: DescriptionLabel, DText: DescriptionText)
        
        /* page message */
        self.show_page_message(s1: exercise_name ?? "Unable to retrieve exercise name", s2: exercise_name ?? "nil")
        
        /* stop button */
        stopButton.timerButtonDesign()
        stopButton.setTitle("STOP", for: .normal)
        stopButton.backgroundColor = Global.color_schemes.m_lightRed
        self.view.addSubview(stopButton)
        
        /* completed Button */
        completedButton.timerButtonDesign()
        completedButton.setTitle("COMPLETED", for: .normal)
        completedButton.backgroundColor = Global.color_schemes.m_blue2
        self.view.addSubview(completedButton)
        
        /* timer label */
        timerLabel.timerDesign()
        self.view.addSubview(timerLabel)
        
        /* gif */
        guard let gif = UIImageView.fromGif(frame: CGRect(x: 0, y: 112, width: 375, height: 300), resourceName: "neck_side_stretch") else { return }
        view.addSubview(gif)
        gif.startAnimating()
        
        /* when entering this page, hide these elements */
        stopButton.isHidden = true
        timerLabel.isHidden = true
        completedButton.isHidden = true
        
        /* we came from routines page */
        if Global.IsRoutineExercise == 1 {
            
            /* Skip button */
            skipButton.skipButtonDesign()
            skipButton.setTitle("SKIP",for: .normal)
            skipButton.backgroundColor = Global.color_schemes.m_lightGreen
            skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            self.view.addSubview(skipButton)
            
            /* start button */
            startButton.timerButtonDesign2()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            self.view.addSubview(startButton)
        }
            
        /* we came from categories page */
        else if Global.IsRoutineExercise == 0 {
            
            /* start button */
            startButton.timerButtonDesign()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            self.view.addSubview(startButton)
        }
    }
    
    /* put code that does not depends on IsRoutineExercise flag in here */
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
    }
    
    /* when home button on navigation bar is tapped */
    @objc func homeButtonTapped(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    /* when skip button is tapped */
    @objc func skipButtonTapped() {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Exercise", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ExerciseVC2")
//        self.present(newViewController, animated: true, completion: nil)
        //print ("log exercise numer: ", exercise_number)
        //print ("log routine_data: ", routine_data)
        //print ("log current exercise: ", self.routine_data[2])
        
        //Global.next_routine_exercise = "WALKING"
        //self.exercise_number += 1
        
        // wrap skip button
        //if self.exercise_number < 2 { self.exercise_number = 1}
    }
    
    /* starts timer */
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    /* decrements timer */
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
        
        /* when countdown is done, hide and show these elements */
        if seconds <= 0 {
            stopButton.isHidden = true
            completedButton.isHidden = false
            timer.invalidate()
        }
    }
}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}


