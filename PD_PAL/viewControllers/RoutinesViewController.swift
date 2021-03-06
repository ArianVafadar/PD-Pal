//
//  RoutinesViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 25 2019, Arian Vafadar, Designed Routine and Subroutine page>
// <October 26, 2019, Arian Vafadar, added pictures and updated Main routine page>
// <November 1, 2019, Spencer Lall, Updated the default page design>
// <November 8, 2019, Izyl Canonicato, Changed the StoryBoard Layout for the Routines>
// <November 9, 2019, Spencer Lall, Put the buttons in the stackview>
// <November 10, 2019, Spencer Lall, passed information into the exercise viewcontroller>
// <November 11, 2019, Izyl Canonicato, Created the viewController button design>

//

import UIKit

class RoutinesViewController: UIViewController {
    // IBOutlet buttons
    @IBOutlet weak var routineButton1: UIButton!
    @IBOutlet weak var routineButton2: UIButton!
    @IBOutlet weak var routineButton3: UIButton!
    //var window: UIWindow?
    
    /* stack view containing exercise buttons */
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [routineButton1, routineButton2, routineButton3])    // elements in stackview
        sv.translatesAutoresizingMaskIntoConstraints = false    // use constraints
        sv.axis = .vertical                                     // stackview orientation
        sv.spacing = 25                                        // spacing between elements
        sv.distribution = .fillEqually
        return sv
    }()
    
    // override seque to send exercise name to destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoutineSegue" {
            let vc = segue.destination as! RoutineGenericViewController
            vc.routine_name = (sender as! UIButton).titleLabel!.text!
            
            /* reset routine index */
            Global.routine_index = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let routineNames = global_UserData.Get_Routines()
        view.backgroundColor = Global.color_schemes.m_bgColor
        
        
        /* page message */
        self.show_page_message(s1: "Select A Routine To Try!", s2: "Routine")

        /* apply titles and designs to routine buttons */
        routineButton1.setTitle(routineNames[0].0, for: .normal)
        routineButton1.routineButtonDesign()
        routineButton1.setBackgroundImage(UIImage(named: "routine1"), for: .normal)
        
        routineButton2.setTitle(routineNames[1].0, for: .normal)
        routineButton2.routineButtonDesign()
        routineButton2.setBackgroundImage(UIImage(named: "routine2"), for: .normal)
        
        routineButton3.setTitle(routineNames[2].0, for: .normal)
        routineButton3.routineButtonDesign()
        routineButton3.setBackgroundImage(UIImage(named: "routine3"), for: .normal)
        
        /* routine button constraints */
        applyExerciseButtonConstraint(button: routineButton1)
        applyExerciseButtonConstraint(button: routineButton2)
        applyExerciseButtonConstraint(button: routineButton3)
        
        self.view.addSubview(stackView)
        applyStackViewConstraints(SV: stackView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
    }
}




