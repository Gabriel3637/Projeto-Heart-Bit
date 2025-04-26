import SwiftUI

enum Genero: String {
    case masc = "Homem"
    case fem = "Mulher"
}

struct CalcIMCView: View {
    
    @State private var altura: String = ""
    @State private var peso: String = ""
    @State private var gen: Genero = .masc
    @State private var imc: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor1.edgesIgnoringSafeArea(.all)
                VStack {
                    titulo
                    imagem
                    butaoGenero

                    TelaMedidas(image: "pencil.and.ruler.fill", text: "Altura (cm)", value: $altura)
                        .fontWeight(.bold)
                    TelaMedidas(image: "scalemass.fill", text: "Peso (kg)", value: $peso)
                        .fontWeight(.bold)

                    Spacer()

                    NavigationLink(
                        destination: resultadoIMC(imc: $imc, genero: gen),
                        label: {
                            Text("Calcular IMC")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .frame(maxWidth: .infinity)
                        }
                    )
                    .simultaneousGesture(TapGesture().onEnded {
                        calcularIMC()
                    })
                    .cornerRadius(30)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .tint(.vermelhoRed)
                }
                .padding()
            }
        }
    }

    
    private var generoSelecionado: String {
        gen == .masc ? "Masc3" : "Fem3"
    }
    
    private var titulo: some View {
        Text("Calculadora de IMC")
            .font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.rounded)
    }
    
    private var imagem: some View {
        Image(generoSelecionado)
            .resizable()
            .scaledToFit()
            .frame(width: 180, height: 260)
    }
    
    private var butaoGenero: some View {
        HStack(spacing: 40) {
            ButaoGenero(gen: .masc, generoSelec: $gen)
            ButaoGenero(gen: .fem, generoSelec: $gen)
        }
        .padding(.bottom, 16)
    }
    
    private func calcularIMC() {
        if let alturaValor = Double(altura), let pesoValor = Double(peso), alturaValor > 0 {
            imc = pesoValor / ((alturaValor / 100) * (alturaValor / 100))
        }
    }
}

struct ButaoGenero: View {
    let gen: Genero
    @Binding var generoSelec: Genero
    
    var body: some View {
        Button(gen.rawValue) {
            generoSelec = gen
        }
        .font(.title3)
        .fontWeight(.bold)
        .fontDesign(.rounded)
        .foregroundColor(.black)
        .opacity(generoSelec == gen ? 1.0 : 0.3)
    }
}

struct TelaMedidas: View {
    let image: String
    let text: String
    @Binding var value: String
    
    var body: some View {
        
        HStack {
            Image(systemName: image)
            Text(text)
            Spacer()
            
            TextField("0", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 80)
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(6)
        .shadow(color: Color(white: 0.9), radius: 3)
        .padding(.vertical, 2)
    }
}

#Preview {
    CalcIMCView()
}
