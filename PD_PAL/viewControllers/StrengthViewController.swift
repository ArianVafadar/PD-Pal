//
//  StrengthViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>
import UIKit

class StrengthViewController: UIViewController {
    
    /* IBOutlet Buttons */
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var exerciseButton2: UIButton!
    @IBOutlet weak var exerciseButton3: UIButton!
    @IBOutlet weak var exerciseButton4: UIButton!
    @IBOutlet weak var exerciseButton5: UIButton!
    
    /* stack view containing exercise buttons */
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [exerciseButton, exerciseButton2, exerciseButton3, exerciseButton4, exerciseButton5])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 25                                        // spacing between elements
        sv.distribution = .fillEqually
        return sv
    }()
        
    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* set IsRoutineExercise flag to 0 to signify we came from categories page */
        if let vcc = segue.destination as? ExerciseViewController { Global.IsRoutineExercise = 0 }
        
        /* use segue to forward pass exercise name to destination exercise view controller */
        if segue.identifier == "StrengthSegue" {
            let vc = segue.destination as! ExerciseViewController
            vc.exercise_name = (sender as! UIButton).titleLabel!.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        logNavigationStack()
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = nil
        let homeButton = UIButton(type: .custom)
        homeButton.applyHomeButton()
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: homeButton)
        self.navigationItem.rightBarButtonItem  = barButton


        /* page message */
        self.show_page_message(s1: "Strength Exercises!", s2: "Strength")
        
        let exercise_list = global_ExerciseData.exercise_names()
        
        /* exercise buttons */
        
        
        //-> button 1
        exerciseButton.setTitle(exercise_list[0],for: .normal)                        // button text
        exerciseButton.exerciseButtonDesign()
        exerciseButton.backgroundColor = Global.color_schemes.m_blue2          // background color

        //-> button 2
        exerciseButton2.setTitle(exercise_list[4],for: .normal)                        // button text
        exerciseButton2.exerciseButtonDesign()
        exerciseButton2.backgroundColor = Global.color_schemes.m_blue2          // background color

        //-> button 3
        exerciseButton3.setTitle(exercise_list[8],for: .normal)                        // button text
        exerciseButton3.exerciseButtonDesign()
        exerciseButton3.backgroundColor = Global.color_schemes.m_blue2          // background color
        
        //-> button 4
        exerciseButton4.setTitle(exercise_list[10],for: .normal)                        // button text
        exerciseButton4.exerciseButtonDesign()
        exerciseButton4.backgroundColor = Global.color_schemes.m_blue2          // background color
        
        //-> button 5
        exerciseButton5.setTitle(exercise_list[12],for: .normal)                        // button text
        exerciseButton5.exerciseButtonDesign()
        exerciseButton5.backgroundColor = Global.color_schemes.m_blue2          // background color
        
        /* exercise buttons constraints */
        applyExerciseButtonConstraint(button: exerciseButton)
        applyExerciseButtonConstraint(button: exerciseButton2)
        applyExerciseButtonConstraint(button: exerciseButton3)
        applyExerciseButtonConstraint(button: exerciseButton4)
        applyExerciseButtonConstraint(button: exerciseButton5)

        
        self.view.addSubview(stackView)
        applyStackViewConstraints(SV: stackView)
    }
    
    
    // called when home button on navigation bar is tapped
    @objc func homeButtonTapped(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
}
