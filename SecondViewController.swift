//
//  SecondViewController.swift
//  ExampleProject
//
//  Created by Abdur Rahim on 7/28/19.
//  Copyright © 2019 Abdur Rahim. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       
    }

    
    

   

}
extension SecondViewController:VCFinalDelegate
{
    func finishPassing(string: String)
    {
        print("Passed data is \(string)")
        titleLabel.text = string
    }
}
