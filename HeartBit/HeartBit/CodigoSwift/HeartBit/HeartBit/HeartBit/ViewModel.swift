//
//  ViewModel.swift
//  trabaio
//
//  Created by Turma01-15 on 03/04/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingError
    case requestFailed
}


class ViewModel: ObservableObject {
    
    @Published var bpms: [bpm] = []
    
    @Published var formularios: [newFormData] = []
    @Published var formulariounico : newFormData?
    
    func fetch(){
        guard let url = URL(string: "http://192.168.128.8:1880/getbatimentosteste") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            
            guard let data = data, error == nil else{
                return
            }
            
            do{
                
                let parsed = try JSONDecoder().decode([bpm].self, from: data)
                
                DispatchQueue.main.async {
                    
                    self?.bpms = parsed
                    self?.bpms.sort(by: {$0.data! > $1.data!})
                }
            } catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func postForm(url: URL, formData: FormData) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(formData)
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Resposta HTTP inválida")
                throw NetworkError.invalidResponse
            }

         
            if let responseString = String(data: data, encoding: .utf8) {
                print("Resposta do servidor: \(responseString)")
            }

        } catch {
            print("Erro durante o envio da requisição: \(error.localizedDescription)")
            throw NetworkError.requestFailed
        }
    }
    
    func putForm(url: URL, newFormData: newFormData) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encodedData = try JSONEncoder().encode(newFormData)
        request.httpBody = encodedData

        let (_, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }




    func fetchForm(){
            guard let url = URL(string: "http://192.168.128.8:1880/getformteste") else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url){[weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                
                do{
                    let parsed = try JSONDecoder().decode([newFormData].self, from: data)
                    
                    DispatchQueue.main.async{
                        print(parsed)
                        self?.formularios = parsed
                        self?.formulariounico = self?.formularios[0]
                    }
                }catch{
                    print(error)
                }
            }
            
            task.resume()
            
            
        }
}
