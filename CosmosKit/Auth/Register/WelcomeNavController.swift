//
//  WelcomeNavController.swift
//  CosmosKit
//
//  Created by DK on 27.11.2022.
//

import Foundation

public class WelcomeNavController: UINavigationController {
    var cosmos: Cosmos!
    
    override public func viewDidLoad() {
        let controller = self.viewControllers[0] as! InformationViewController
        controller.cosmos = cosmos
    }
}
