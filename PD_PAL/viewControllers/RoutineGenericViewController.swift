//
//  RoutineGenericViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-25.
//  Copyright © 2019 WareOne. All rights reserved.
//
//Revision History:
// <Date, Name, Changes made>
// <October 25 2019, Arian Vafadar, Designed Routine and Subroutine page>
//

import UIKit

class RoutineGenericViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Setup.m_bgColor
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


