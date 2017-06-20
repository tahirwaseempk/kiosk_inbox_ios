//
//  SplashViewController.swift
//  Inbox
//
//  Created by tahir on 20/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLoginView()
    }

    
    func loadLoginView()
    {
        
        let dispatchTime = DispatchTime.now() + .seconds(1)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            let homeStoryboard = UIStoryboard(name:"Login", bundle: nil)
            
            let homeViewController: UIViewController = homeStoryboard.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
            self.navigationController?.setViewControllers([homeViewController], animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
