//
//  HelloApplicationViewController.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import UIKit

class HelloApplicationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startNow(_ sender: Any) {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
