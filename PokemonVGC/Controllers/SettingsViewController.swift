//
//  SettingsViewController.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/19/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationButtons()
    }
    
    private func addNavigationButtons() {
        let test = UIBarButtonItem(title: "Test", style: .done, target: self, action: #selector(runTest(_:)))
        self.navigationItem.rightBarButtonItem = test
    }
    
    @objc func runTest(_ sender:UIBarButtonItem) {
        print("Running")
        let urlStr = "https://3ds.pokemon-gl.com/frontendApi/gbu/getSeasonPokemon"
        
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        let params:[String:Any] = ["languageId":2, "seasonId":312, "battleType":0, "timezone":"EDT", "timestamp":Date().timeIntervalSince1970]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("JSESSIONID=5C3503BE87DDAD785E84C8CAC5A319BB; AWSELB=C95303410E583113FAF27D987FE57908F5BE8EE44B1D78C36071E487045C61D92B83F0D1F6A57BBBD282D9EB0D0545DE781EF8C4F1C61BCB91CC5E1D6399F2BF7AC1E64A4D5323C3E82E01EC5E36CFE72D3A225991; _ga=GA1.2.145784229.1537651123; _gid=GA1.2.1242762003.1537651123; NO_MEMBER_DATA=%7B%22language_id%22%3A2%2C%22site%22%3A2%2C%22region%22%3A1%7D; __ulfpc=201809221418440629; s_fid=683DB88A4D319203-2C02C0E62879E2DE; s_cc=true; PGLLOGINTIME=1537651196353; _gat=1", forHTTPHeaderField: "Cookie")
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            print("Running Data Task")
            if let e = error {
                print(e.localizedDescription)
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                return
            }
            
            if let d = data {
                let str = String(data: d, encoding: .utf8) ?? "No Data"
                print(str)
            } else {
                print("No Data")
            }
        }
        //task.resume()
    }
}
