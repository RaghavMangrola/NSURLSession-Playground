//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum Errors {
    case error, data
}

let defaultSession = URLSession(configuration: .default)
var dataTask: URLSessionDataTask?
let urlString: String = "https://nsurlsession-tutorial.firebaseio.com/.json"
let requestUrlString: String = "https://nsurlsession-tutorial.firebaseio.com/Data.json"

func downloadData() {
    guard let url = URL(string: urlString) else {
        return
    }
    
    dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
        
        if let error = error {
            print(error)
        } else if let data = data {
            
            guard let response  = response as? HTTPURLResponse else {
                return
            }
            
            print("Status code: \(response.statusCode)")
            
            guard let jsonData = convertDataToJson(data: data) else {
                return
            }
            
            print(jsonData)
        }
        
        
    })
    
    dataTask?.resume()
}

func convertDataToJson(data: Data) -> Any? {
    
    do {
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    } catch {
        print(error)
    }
    
    return nil
}


func postData() {
    guard let url = URL(string: requestUrlString) else {
        return
    }

    let dictionary: [String: Any] = ["byeWorld": "Bye World"]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = convertJsonToData(json: dictionary) as? Data

    dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
        if let error = error {
            print(error)
        } else if let data = data {
            guard let response  = response as? HTTPURLResponse else {
                return
            }

            print("Status code: \(response.statusCode)")

            guard let jsonData = convertDataToJson(data: data) else {
                return
            }

            print(jsonData)
        }
    })

    dataTask?.resume()
}

func convertJsonToData(json: [String: Any]) -> Any? {
    do {
        return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    } catch {
        print(error)
    }

    return nil
}

downloadData()
postData()
