//
//  searchResult.swift
//  FunNBA
//
//  Created by David  on 2018-06-11.
//  Copyright © 2018 David . All rights reserved.
//

import Foundation

class SearchResult {
    
    struct ResultArray: Codable {
        let resource: String
        let parameters: Parameter
        let resultSets: [Results]
    }
    
    struct Parameter: Codable {
        let TeamID: Int
        let LeagueID: String
        let Season: String
        let SeasonType: String
        let DateFrom: String?
        let DateTo: String?
    }
    
    struct Results: Codable {
        let name: String
        let headers: [String]
        let rowSet: [rowDetail]
        
    }
    
    struct rowDetail: Codable {
        let TeamID: Int
        let GameID: String
        let GAMEDATE: String
        let MATCHUP: String
        let WL: String
        /* let W: Int
         let L: Int
         let WPCT: Float
         let MIN: Int
         let FGM: Int
         let FGA: Int
         let FGPCT: Float
         let FG3M: Int
         let FG3A: Int
         let FG3PCT: Float
         let FTM: Int
         let FTA: Int
         let FTPCT: Float
         let OREB: Int
         let DREB: Int
         let REB: Int
         let AST: Int
         let STL: Int
         let BLK: Int
         let TOV: Int
         let PF: Int
         let PTS: Int*/
        
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            self.TeamID = try container.decode(Int.self)
            self.GameID = try container.decode(String.self)
            self.GAMEDATE = try container.decode(String.self)
            self.MATCHUP = try container.decode(String.self)
            self.WL = try container.decode(String.self)
        }
        
        // if you need encoding (if not, make Bet Decodable
        // and remove this method)
        func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(TeamID)
            try container.encode(GameID)
            try container.encode(GAMEDATE)
            try container.encode(MATCHUP)
            try container.encode(WL)
        }
        
    }
}

