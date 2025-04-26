import SwiftUI
import GoogleGenerativeAI

struct resultadoIMC: View {
    @Binding var imc: Double
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    @State var userPrompt = ""
    @State var response = "How can I help you today?"
    @State var isLoading = false
    
    let genero: Genero
    
    var resultado: String {
        switch imc {
        case 0..<16: return "Magreza"
        case 16..<18.5: return "Abaixo do peso"
        case 18.5..<25: return "Peso ideal"
        case 25..<30: return "Sobrepeso"
        default: return "Obesidade"
        }
    }
    
    var imagem: String {
        let prefixo = genero == .masc ? "Masc" : "Fem"
        
        switch imc {
        case 0..<16: return "\(prefixo)1"
        case 16..<18.5: return "\(prefixo)2"
        case 18.5..<25: return "\(prefixo)3"
        case 25..<30: return "\(prefixo)4"
        default: return "\(prefixo)5"
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor1.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Image(imagem)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                    
                    Text("O seu resultado de IMC é: **\(String(format: "%.2f", imc))**")
                        .font(.title2)
                        .foregroundStyle(.black)
                    
                    Text(resultado)
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.vermelhoRed)
                    
                    Spacer()
                    
                    ZStack {
                        // Estilizando o texto da resposta
                        VStack{
                            HStack{
                                Text("Dica Gemini")
                                    .font(.custom("HelveticaNeue-Bold", size: 30))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple, .blue, .indigo]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                Image(systemName: "star.fill")
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple, .blue, .indigo]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            Text(response)
                                .font(.body)
                                .foregroundColor(.black)
                                .lineSpacing(8)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(Color.white.opacity(1))
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding(.bottom,10)
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                            }
                        }
                    }
                    
                }
                .padding()
                .onAppear {
                    // Definindo o prompt com informações sobre o IMC
                    userPrompt = "Meu IMC é \(imc) , por favor me dê dicas para eu ter uma boa alimentação e melhorar meu quadro de saúde, me dê uma resposta de até 5 linhas."
                    generateResponse()
                }
            }.background(Color.backgroundColor1)

        }
    }
    
    func generateResponse() {
        isLoading = true
        response = ""
        
        Task {
            do {
                let result = try await model.generateContent(userPrompt)
                isLoading = false
                response = result.text ?? "No response found"
                userPrompt = ""
            } catch let error {
                isLoading = false
                response = "Algo deu errado: \(error.localizedDescription)"
                print("Erro ao gerar resposta: \(error)")
            }
        }
    }
}

#Preview {
    resultadoIMC(imc: .constant(10), genero: .masc)
}
