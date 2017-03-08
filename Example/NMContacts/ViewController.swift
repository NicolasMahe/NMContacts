//
//  ViewController.swift
//  NMContacts
//
//  Created by nicolas@mahe.me on 03/08/2017.
//  Copyright (c) 2017 nicolas@mahe.me. All rights reserved.
//

import UIKit
import NMContacts

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let _ = NMContacts.requestAccess
      .then { _ -> Void in
        let contacts = try NMContacts.fetchContacts()
        //also work with search
        //let contacts = try NMContacts.fetchContacts(search: "string to search")
        print(contacts)
      }
      .catch { (error: Error) in
        print("error")
        print(error)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

