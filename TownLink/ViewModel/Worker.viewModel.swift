//
//  WorkerViewModel.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import Foundation


import Combine

final class WorkerStore: ObservableObject {
    @Published var items: [Worker] = []
    let session: URLSession = {
             let configuration = URLSessionConfiguration.default
             configuration.timeoutIntervalForRequest = TimeInterval(7)
             configuration.timeoutIntervalForResource = TimeInterval(7)
             return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
         }()
        
    init() {
        self.items = [
//            Worker.init(uuid: UUID().uuidString, firstName: "firstName", lastName: "LastName", photoURL: "", isVerified: true, score: 1, vehicleType: 2, remark: "sss", distance: 0.55, ),
            .init(name: "Name", city: "Bish", remark: "Tes", distance: 0, avatar: "d", isVerified: true, flyDate: "ddd"),
            .init(name: "Nadddme", city: "Bish", remark: "Tes", distance: 0, avatar: "d", isVerified: true, flyDate: "ddd"),
            .init(name: "Name", city: "Bish", remark: "Tes", distance: 0, avatar: "d", isVerified: true, flyDate: "ddd"),
            .init(name: "Nadddme", city: "Bish", remark: "Tes", distance: 0, avatar: "d", isVerified: true, flyDate: "ddd"),
            .init(name: "Name", city: "Bish", remark: "Tes", distance: 0, avatar: "d", isVerified: true, flyDate: "ddd"),
            .init(name: "Nadddme", city: "Bish", remark: "Tes", distance: 0, avatar: "d", isVerified: true, flyDate: "ddd")
        ]
    }
            
    func fetch() {
//        if let url = URL(string: URL_END_POINT + "event?lat=3.115362&lng=101.665124&dist=5") {
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            session.dataTask(with: request) { jsonData, res, err in
//                if let data = jsonData {
//                    do {
//                        let items = try JSONDecoder().decode(Worker.self, from: data)
//                        DispatchQueue.main.async {
//                            self.append(items: items)
//                        }
//                    } catch let e {
//                        print(e.localizedDescription)
//                    }
//                }
//            }
//            .resume()
//        }
    }
    
    
    func append(items: [Worker]) {
//        if (self.items.count == 0) {
//            self.items.append(contentsOf: items)
//        } else {
//            for item in items {
//                if (!self.items.contains(where: {$0.eventId == item.eventId})) {
//                    self.items.append(item)
//                }
//            }
//        }
    }
    
    func insert(item: Worker) {
//        if let url = URL(string: URL_END_POINT + "event") {
//            var request = URLRequest(url: url)
//            do {
//                let jsonData = try JSONEncoder().encode(item)
//                request.httpBody = jsonData
//                request.httpMethod = "POST"
//            } catch let e {
//                print(e.localizedDescription)
//            }
//            
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Accept-Type")
//            
//            session.dataTask(with: request) { jsonData, res, err in
//                if let data = jsonData {
//                    do {
//                        let item = try JSONDecoder().decode(EventElement.self, from: data)
//                        DispatchQueue.main.sync {
//                            self.items.append(item)
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            .resume()
//            
//        }
        
        
    }
    
}

