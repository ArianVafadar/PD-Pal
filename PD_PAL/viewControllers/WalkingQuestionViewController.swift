//
//  WalkingQuestionViewController.swift
//  PD_PAL
//
//  Created by icanonic on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//<Date, Name, Changes made>
//<Oct. 27, 2019, Izyl Canonicato, programmatic labels >
//<Oct. 28, 2019, Izyl Canonicato, Navigation to Routines (Home page)>
//<Nov. 1, 2019, Izyl Canonicato, Slider functionality)>
//<Nov. 2, 2019, Izyl Canonicato, Update/Insert WalkingDuration in UserData>

import UIKit

class WalkingQuestionViewController: UIViewController {
    //Buttons
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    //Labels
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var walkingVal: UILabel!
    @IBOutlet weak var Instruction: UILabel!
    var walkingDurationVal = 0
    
    //Slider input
    @IBAction func sliderChanged(_ sender: UISlider) {
        var newValue = roundf(slider.value)
        slider.value = newValue
        walkingDurationVal = Int((sender.value)*5)
        if(newValue == 6){
            walkingVal.text = String(walkingDurationVal) + " mins +"
        } else{
            walkingVal.text = String(walkingDurationVal) + " mins"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Question
        QuestionLabel.text = "How long would you like your walking exercises to be?"
        QuestionLabel.applyQuestionDesign()
        
        //Instruction
        Instruction.text = "(Hold and drag to select a time)"
        Instruction.textAlignment = .center
        Instruction.numberOfLines = 2
        Instruction.textColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        
        //Slider
        walkingVal.text = "0 mins"
        walkingVal.textAlignment = .center
        walkingVal.applyQlabels()
        walkingVal.textColor = Global.color_schemes.m_blue1
        slider.questionnaireSlider()
        
        //Navigation Buttons
        completeButton.applyNextQButton()
        backButton.applyPrevQButton()
        
    }
    
    // checking navigation stack
    override func viewDidAppear(_ animated: Bool) {
        var viewC = self.navigationController?.viewControllers
        print("Log: VC from Walking", viewC!)
    }
    
    // Navigation to previous VC
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.backToViewController(vc: EquipmentQuestionnaireViewController.self)
    }
    
    // Navigation to main storyboard
    @IBAction func completeTapped(_ sender: UIButton) {
        //Update user's preferred walking duration
    global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: true, walkingDuration: walkingDurationVal, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        print(global_UserData.Get_User_Data())
        
        if Global.questionnaire_index == 1 {
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            //self.navigationController?.popToRootViewController(animated: true)
            print("Log: Dismissed NC Stack")
        } else {
            //Global.questionnaire_index = 1
            //print("Log: Pushed onto NC Stack")
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
//            self.present(newViewController, animated: true, completion: nil)
            //print("Log: From Cold start")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let secondViewController = mainStoryboard.instantiateViewController(withIdentifier: "CategoriesPage")
                let navController = UINavigationController(rootViewController: secondViewController)
                navController.setViewControllers([secondViewController], animated:true)
                self.navigationController?.pushViewController(secondViewController, animated: true)
                print("Log: Pushed onto NC Stack")
        }
    }
}
