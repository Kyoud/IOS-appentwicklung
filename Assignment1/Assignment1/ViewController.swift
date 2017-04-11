//
//  ViewController.swift
//  Assignment1
//
//  Created by app on 11.04.17.
//  Copyright © 2017 h-da. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Display: UITextField!

    @IBAction func touchDigit(_ sender: UIButton) {
        print("Hello World!")
        print(sender.currentTitle!)
        Display.text = Display.text! + sender.currentTitle!
        Display.backgroundColor = sender.backgroundColor
    }


}

