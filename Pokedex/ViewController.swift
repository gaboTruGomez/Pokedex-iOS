//
//  ViewController.swift
//  Pokedex
//
//  Created by Gabriel Trujillo Gómez on 6/29/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playMusicBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio()
    {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do
        {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }
        catch let err as NSError
        {
            print(err.debugDescription)
        }
    }
    
    
    // ----- Parsing Pokemon (CSV) Data
    
    func parsePokemonCSV()
    {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do
        {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows
            {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemons.append(poke)
            }
        }
        catch let err as NSError
        {
            print(err.debugDescription)
        }
    }
    
    
    // ----- CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell
        {
            let poke: Pokemon!
            
            if inSearchMode
            {
                poke = filteredPokemons[indexPath.row]
            }
            else
            {
                poke = pokemons[indexPath.row]
            }
            cell.configureCell(pokemon: poke)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var poke: Pokemon!
        if inSearchMode
        {
            poke = filteredPokemons[indexPath.row]
        }
        else
        {
            poke = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if inSearchMode
        {
            return filteredPokemons.count
        }
        return pokemons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 105, height: 105)
    }
    
    
    // ----- SearchBar Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text == nil || searchBar.text == ""
        {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }
        else
        {
            inSearchMode = true

            let lower = searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({ $0.name.range(of: lower) != nil })
            collectionView.reloadData()
        }
    }
    
    
    // ----- Prepping passing to new VC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "PokemonDetailVC"
        {
            if let detailsVC = segue.destination as? PokemonDetailVC
            {
                if let poke = sender as? Pokemon
                {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    @IBAction func playMusicBtnPressed(_ sender: Any)
    {
        if musicPlayer.isPlaying
        {
            musicPlayer.pause()
            playMusicBtn.alpha = 0.2
        }
        else
        {
            musicPlayer.play()
            playMusicBtn.alpha = 1.0
        }
    }
}

