//
//  PokeCell.swift
//  Pokedex
//
//  Created by Gabriel Trujillo Gómez on 6/29/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon)
    {
        self.pokemon = pokemon
        
        self.nameLabel.text = pokemon.name
        self.thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
    }
}
