//
//  LocalizeMe.swift
//  LocalizeMe
//
//  Created by Stefano on 04/08/16.
//  Copyright © 2016 Stefano Venturin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ciAO = LocalizeMe.displayNameForLanguage(language: "en")
        
        print(ciAO)
        label.text = "ciao".localizeMe()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

