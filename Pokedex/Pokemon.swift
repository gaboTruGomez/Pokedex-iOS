//
//  Pokemon.swift
//  Pokedex
//
//  Created by Gabriel Trujillo Gómez on 6/29/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon
{
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
        set {
            _description = newValue
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
        set {
            _type = newValue
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
        set {
            _defense = newValue
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            return _height
        }
        set {
            _height = newValue
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
        set {
            _weight = newValue
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
        set {
            _attack = newValue
        }
    }
    
    var nextEvolutionTxt: String {
        get {
            if _nextEvolutionTxt == nil {
                _nextEvolutionTxt = ""
            }
            return _nextEvolutionTxt
        }
        set {
            _nextEvolutionTxt = newValue
        }
    }
    
    var nextEvolutionName: String {
        get {
            if _nextEvolutionName == nil {
                _nextEvolutionName = ""
            }
            return _nextEvolutionName
        }
        set {
            _nextEvolutionName = newValue
        }
    }

    
    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
        set {
            _nextEvolutionId = newValue
        }
    }

    
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {
                _nextEvolutionLevel = ""
            }
            return _nextEvolutionLevel
        }
        set {
            _nextEvolutionLevel = newValue
        }
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name.capitalized
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON_API)\(self.pokedexId)"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete)
    {
        Alamofire.request(self._pokemonURL).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, Any>
            {
                if let weight = dict["weight"] as? String
                {
                    self._weight = weight
                }
                if let height = dict["height"] as? String
                {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int
                {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int
                {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0
                {
                    if let name = types[0]["name"]
                    {
                        self._type = name.capitalized
                    }
                    if types.count > 1
                    {
                        for x in 1..<types.count
                        {
                            if let name = types[x]["name"]
                            {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0
                {
                    if let url = descArr[0]["resource_uri"]
                    {
                        let descURL = "\(URL_BASE)\(url)"
                        Alamofire.request(descURL).responseJSON(completionHandler: { response in
                            if let descDict = response.result.value as? Dictionary<String, Any>
                            {
                                if let description = descDict["description"] as? String
                                {
                                    let newDesc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                    print(newDesc)
                                }
                            }
                            completed()
                        })
                    }
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] , evolutions.count > 0
                {
                    if let nextEvo = evolutions[0]["to"] as? String
                    {
                        if nextEvo.range(of: "mega") == nil
                        {
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String
                            {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"]
                                {
                                    if let lvl = lvlExist as? Int
                                    {
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                }
                            }
                        }
                    }
                    print(self._nextEvolutionLevel)
                    print(self._nextEvolutionName)
                    print(self._nextEvolutionId)
                }
            }
            completed()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
