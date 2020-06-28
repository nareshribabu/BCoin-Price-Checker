//
//  CoinManager.swift
//  BitCoinPrice
//  Created by Nareshri Babu on 23/04/2020.
//  Concept by London App Brewery
//  Copyright © 2020 Nareshri Babu. All rights reserved.
//  This app was created for learning purposes.
//  All images were only used for learning purposes and do not belong to me.
//  All sounds were only used for learning purposes and do not belong to me.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = ""
    let apiKey = ""
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    func getCoinPrice (for currency : String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //print(urlString)
        
    
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession (like out browser, the thing that can perfrom networking)
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in //this is a closure
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let bitcoinPriceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: bitcoinPriceString, currency: currency)
                    }
                    
                }
            }
            
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        //create a decoder to decode JSON
        let decoder = JSONDecoder()
        
        //use the decoder to decode
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let coinRate = decodedData.rate
            print(coinRate)
            return coinRate
        }
        catch {
            print(error)
            return nil
        }
        
    }
}
