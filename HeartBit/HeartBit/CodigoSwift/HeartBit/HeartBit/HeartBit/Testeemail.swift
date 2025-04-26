import Foundation
class Testeemail : ObservableObject{
    func sendEmail(formulario : newFormData, latitude : Double, longitude: Double) {
        
        
        // Defina a URL da API
        guard let url = URL(string: "https://api.mailersend.com/v1/bulk-email") else {
            print("URL inválida")
            return
        }
        
        var listaemergencia: String = ""
        var listadoencas: String = ""
        var listacontatos: [String] = []
                
                for contato in formulario.emergencyContacts {
                    listaemergencia = "\(listaemergencia)\(contato.nome): \(contato.email)<br>"
                    listacontatos.append(contato.email)
                }
        
        
        
        
        for (doenca, estado) in formulario.healthIssues {
            if(estado){
                    listadoencas = "\(listadoencas)\(doenca), "
            }
            
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
         
    var emailData: [[String: Any]] = []
        // Crie o dicionário com os dados do e-mail
        for contato in listacontatos{
            emailData.append([
                    "from": [
                        "email": "MS_CipwmG@test-68zxl27rd634j905.mlsender.net"
                    ],
                    "to": [
                        [
                            "email": "\(contato)"
                        ]
                    ],
                    "subject": "Emergência! Estou passando mal!",
                    "text": "O usuário: \(formulario.name) esta passando mal!",
                    "html": "<!DOCTYPE html><html lang=\"pt-br\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title>Emergência</title><link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200\"></head><body style=\"font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0;\"><h1 style=\"text-align: center; background-color: red; color: white; font-weight: 900; padding: 10px; margin: 0;\">Emergência! Estou passando mal!</h1><p style=\"text-indent: 50px; margin: 10px;\">Você é o contato de emergência do usuário. Detectamos alterações nos batimentos cardíacos. Recomendamos que tente entrar em contato; caso não consiga, envie ajuda para a localização abaixo:</p><p style=\"text-align: center; margin: 10px;\"><a href=\"https://waze.com/ul?ll=\(latitude),\(longitude)&navigate=yes\" style=\"text-decoration: none; color: #000;\"><img src=\"https://cdn-icons-png.flaticon.com/512/7488/7488279.png\" alt=\"\"><div>Abrir localização no Waze</div></a></p><p style=\"text-indent: 50px; margin: 10px;\">Os dados médicos do usuário seguem abaixo:</p><div style=\"margin: 10px;\"><div style=\"display: block;\"><strong>Dados Pessoais:</strong><br><span style=\"display: block;\">Nome: \(formulario.name)</span><span style=\"display: block;\">CPF:\(formulario.cpf)</span><span style=\"display: block;\">RG:\(formulario.rg)</span><span style=\"display: block;\">Telefone:\(formulario.phone)</span><span style=\"display: block;\">Naturalidade:\(formulario.naturalidade)</span><span style=\"display: block;\">Endereço:\(formulario.address)</span><span style=\"display: block;\">Bairro:\(formulario.neighborhood)</span><span style=\"display: block;\">Cidade:\(formulario.city)</span><span style=\"display: block;\">CEP:\(formulario.postalCode)</span><span style=\"display: block;\">Estado:\(formulario.state)</span><span style=\"display: block;\">Tipo sanguíneo:\(formulario.bloodType)</span><span style=\"display: block;\">Data de nascimento:\(formatter.string(from: formulario.birthDate))</span></div><div style=\"display: block; margin-top: 20px;\"><strong>Dados Médicos:</strong><br><span style=\"display: block;\">Plano de saúde:\(formulario.healthPlan)</span><span style=\"display: block;\">Cartão do SUS: \(formulario.susCard)</span><span style=\"display: block;\">Nome do médico:\(formulario.doctorName)</span><span style=\"display: block;\">Telefone do médico:\(formulario.doctorPhone)</span><span style=\"display: block;\">Contatos de emergência:<br>\(listaemergencia)</span><span style=\"display: block;\">Histórico médico:\(formulario.medicalHistory)</span><span style=\"display: block;\">Possui alergias:\( formulario.isAllergic ? "Sim" : "Não")</span><span style=\"display: block;\">Alergias:\( formulario.isAllergic ? formulario.allergyDetails : "Não possui alergias conhecidas")</span><span style=\"display: block;\">Possui histórico de AVC: \( formulario.hasSeizures ? "Sim" : "Não")</span><span style=\"display: block;\">Histórico de AVC: \( formulario.hasSeizures ? formulario.seizureDetails : "Nunca teve AVC")</span><span style=\"display: block;\">Fez alguma cirurgia: \( formulario.surgeryDone ? "Sim" : "Não")</span><span style=\"display: block;\">Detalhes cirúrgicos:\( formulario.surgeryDone ? formulario.surgeryDetails : "Não")</span><span style=\"display: block;\">Costumo tomar quando estou com febre: \(formulario.feverMedication)</span></span><span style=\"display: block;\">Problemas de saúde: \(listadoencas)</span></div></div></body></html>"
                ])
        }
        
        // Tente converter o dicionário para JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: emailData, options: []) else {
            print("Erro ao converter os dados para JSON")
            return
        }
        
        // Crie a requisição
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.setValue("Bearer mlsn.3eecccc0f59fc92c7dfc1d75e0762d9f02a445f276b6aa3707ce469efff098d2", forHTTPHeaderField: "Authorization") // Substitua pelo seu API Token
        
        // Defina o corpo da requisição com os dados JSON
        request.httpBody = jsonData
        
        // Crie a sessão de requisição
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("E-mail enviado com sucesso!")
                } else {
                    print("Erro na requisição. Código de status: \(httpResponse.statusCode)")
                }
            }
        }
        
        // Inicie a tarefa
        task.resume()
    }
}
