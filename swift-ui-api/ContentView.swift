//
//  ContentView.swift
//  swift-ui-api
//
//  Created by Eoan on 18/03/2020.
//  Copyright © 2020 WebSpace. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) {item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
            }
        }
            //Run the loadData function on mount
    .onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=queen&entity=song") else {
            print("invalid url")
            return
        }
        
        let request = URLRequest(url: url)
        
        /**
            Creates a networking task from the url request
            Takes three parameters:
         
             `data` - returned from request
             `response` - description of data, status, weight etc
             `error` - if an error had occured
         
             .resume ensures the request starts immediately in the background
                and is controlled by the system
         */
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Runs after .resume() has been completed
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    //Go back to the main thread
                    DispatchQueue.main.async {
                        //Update the results
                        self.results = decodedResponse.results
                    }
                    
                    //Return and exit the function
                    return
                }
            }
            
            //Since we return after the DispatchQueue,
            //This code will only run if there is an error
            //with the data
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
