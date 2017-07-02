//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Gabriel Trujillo Gómez on 6/30/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController
{
    var pokemon: Pokemon!
    
    @IBOutlet weak var pokeNameLabel: UILabel!
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeDesc: UILabel!
    @IBOutlet weak var pokeTypeLabel: UILabel!
    @IBOutlet weak var pokeHeightLabel: UILabel!
    @IBOutlet weak var pokeWeightLabel: UILabel!
    @IBOutlet weak var pokeDefenseLabel: UILabel!
    @IBOutlet weak var pokeIdLabel: UILabel!
    @IBOutlet weak var pokeBaseAtackLabel: UILabel!
    @IBOutlet weak var nextEvoLabel: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        pokeNameLabel.text = pokemon.name
        pokeImg.image = UIImage(named: "\(pokemon.pokedexId)")
        pokeIdLabel.text = "\(pokemon.pokedexId)"
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetail {
            // This is called when download is completed
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        pokeHeightLabel.text = pokemon.height
        pokeWeightLabel.text = pokemon.weight
        pokeDefenseLabel.text = pokemon.defense
        pokeBaseAtackLabel.text = pokemon.attack
        pokeTypeLabel.text = pokemon.type
        pokeDesc.text = pokemon.description
        
        if pokemon.nextEvolutionId == ""
        {
            nextEvoLabel.text = "No Evolutions"
            nextEvoImg.isHidden = true
        }
        else
        {
            nextEvoLabel.text = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any)
    {
        dismiss(animated: true)
    }
}
