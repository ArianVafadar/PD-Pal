//
//  WallPushUpViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class WallPushUpViewController: UIViewController {
    @IBOutlet var ExerciseLabel: UILabel!
    @IBOutlet var DescriptionLabel: UILabel!
    @IBOutlet var DurationLabel: UILabel!
    @IBOutlet var SelectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ExerciseLabel.ExerciseDesign()
        DescriptionLabel.DescriptionDurationDesign()
        DurationLabel.DescriptionDurationDesign()
        SelectButton.DesignSelect()

        // home button on navigation bar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.rightBarButtonItem  = homeButton

        // Do any additional setup after loading the view.
    }
    
    // called when home button on navigation bar is tapped
    @objc func homeButtonTapped(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

