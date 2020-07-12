//
//  RandomViewController.swift
//  Cocktail DB
//
//  Created by MG on 12.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import AlamofireImage

class RandomViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerManager().getRandomDrink { (randomDrink) in 
            
            self.drinkName.text = randomDrink.drinkName
            self.descriptionLabel.text = randomDrink.description
            guard let url = randomDrink.urlImage else { return }
            self.imageView?.af.setImage(withURL: url)
        }
    }

}
