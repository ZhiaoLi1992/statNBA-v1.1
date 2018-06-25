//
//  ViewController.swift
//  statNBA
//
//  Created by David  on 2018-06-24.
//  Copyright © 2018 David . All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var label: UILabel!
    
    var isLoading = false
    var hasSearched = false
    var searchResults = [SearchResult.Results]()
    
    var totalGameWon = 0
    var dataTask: URLSessionDataTask?
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        print("Segment changed: \(sender.selectedSegmentIndex)")
        
        performSearch()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        tableView.rowHeight = 100
        label.text = "0 / 82"
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MatchHistory")
        
        
        
        //dimiss keyboard when anywhere out side keyboard is clicked
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func statNBAURL(teamId: String, category: Int) -> URL {
        let season: String
        switch category {
        case 0: season = "2016-17"
        case 1: season = "2015-16"
        case 2: season = "2014-15"
        case 3: season = "2013-14"
        case 4: season = "2012-13"
        case 5: season = "2011-12"
        case 6: season = "2010-11"
        case 7: season = "2009-10"
        default:
            season = "2016-17"
        }
        
        
        let urlString = "https://stats.nba.com/stats/teamgamelog?" + "LeagueID=00&Season=\(season)&SeasonType=Regular+Season&teamid=\(teamId)"
        let url = URL(string: urlString)
        return url!
    }
    
    func teamIdLookUp(teamName: String) -> String {
        let teamId: String
        switch teamName {
        case "Atlanta Hawk":  teamId = "1610612737"
        case "Boston Celtics":  teamId = "1610612738"
        case "Brooklyn Nets":   teamId = "1610612751"
        case "Charlotte Hornets":  teamId = "1610612766"
        case "Chicago Bulls":  teamId = "1610612741"
        case "Cleveland Cavaliers":  teamId = "1610612739"
        case "Dallas Mavericks": teamId = "1610612742"
        case "Denver Nuggets":  teamId = "1610612743"
        case "Detroit Pistons":  teamId = "1610612765"
        case "Golden State Warriors": teamId = "1610612744"
        case "Houston Rockets":  teamId = "1610612745"
        case "Indiana Pacers":  teamId = "1610612754"
        case "Los Angeles Clippers":  teamId = "1610612746"
        case "Los Angeles Lakers":  teamId = "1610612747"
        case "Memphis Grizzlies":   teamId = "1610612763"
        case "Miami Heat":   teamId = "1610612748"
        case "Milwaukee Bucks":  teamId = "1610612749"
        case "Minnesota Timberwolves": teamId = "1610612750"
        case "New Orleans Pelicans":  teamId = "1610612740"
        case "New York Knicks":   teamId = "1610612752"
        case "Oklahoma City Thunder":  teamId = "1610612760"
        case "Orlando Magic":   teamId = "1610612753"
        case "Philadelphia 76ers":  teamId = "1610612755"
        case "Phoenix Suns":   teamId = "1610612756"
        case "Portland Trail Blazers":  teamId = "1610612757"
        case "Sacramento Kings":   teamId = "1610612758"
        case "San Antonio Spurs": teamId = "1610612759"
        case "Toronto Raptors":  teamId = "1610612761"
        case "Utah Jazz":   teamId = "1610612762"
        case "Washington Wizards": teamId = "1610612764"
        default: teamId = ""
        }
        return teamId
    }
    
    func parse(data: Data) -> [SearchResult.Results] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(SearchResult.ResultArray.self, from: data)
            //print("%@", result.resultSets.isEmpty)
            return result.resultSets
        } catch {
            print("JSON error: \(error)")
            return []
        }
    }


}

extension SearchViewController: UISearchBarDelegate {
   
   func performSearch(){
            if !searchBar.text!.isEmpty {
                searchBar.resignFirstResponder()
                isLoading = true
                tableView.reloadData()
                hasSearched = true
                searchResults = []
                
                let teamA = searchBar.text!
                let tID = teamIdLookUp(teamName: teamA)
                let url = statNBAURL(teamId: tID, category: segmentedControl.selectedSegmentIndex)
                print(url)
                let session = URLSession.shared
                dataTask = session.dataTask(with: url,
                                            completionHandler: {
                                                data, response, error in
                                                if let data = data {
                                                    self.searchResults = self.parse(data: data)
                                                    let gamePlayed = self.searchResults[0].rowSet.count
                                                    print(" \(gamePlayed)")
                                                    var gameWon = 0
                                                    //print(self.searchResults[0].rowSet[1])
                                                    
                                                    for game in self.searchResults[0].rowSet {
                                                        if game.WL == "W" {
                                                            gameWon = gameWon + 1
                                                        }   
                                                    }
                                                    print("\(gameWon)")
                                                    self.totalGameWon = gameWon
                                                    //print("\(self.totalGameWon)")
                                                    print("TEST")
                                                    
                                                    DispatchQueue.main.async {
                                                        self.isLoading = false
                                                        self.tableView.reloadData()
                                                    }
                                                    
                                                    
                                                    
                                                    //print(" \(self.searchResults[0].rowSet[1])")
                                                    //print(" \(self.searchResults[0].rowSet[2])")
                                                    return
                                                }
                                                DispatchQueue.main.async {
                                                    self.hasSearched = false
                                                    self.isLoading = false
                                                    self.tableView.reloadData()
                                                }
                })
                dataTask?.resume()
                
            }
        }
        
        func position(for bar: UIBarPositioning) -> UIBarPosition {
            return .topAttached
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            performSearch()
            
            
            
        }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else {
            return searchResults[0].rowSet.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MatchHistory"
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            //May go wrong!!!!
            print(searchResults[0].rowSet[1])
            let searchResult = searchResults[0].rowSet
            if (searchResult[indexPath.row].WL == "W"){
                cell.textLabel?.text  = searchResult[indexPath.row].GAMEDATE + " " + searchResult[indexPath.row].MATCHUP + " " + searchResult[indexPath.row].WL
               
                // cell.backgroundColor = UIColor.lightGray
            } else {
                cell.textLabel?.text  = searchResult[indexPath.row].GAMEDATE + " " + searchResult[indexPath.row].MATCHUP + " " + searchResult[indexPath.row].WL
            }
            label.text = String(totalGameWon) + "/82"
            return cell
        }
    }
}

