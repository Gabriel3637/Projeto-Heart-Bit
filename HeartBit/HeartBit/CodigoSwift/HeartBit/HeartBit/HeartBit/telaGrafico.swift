import SwiftUI
import Charts

struct GradientAreaChartExampleView: View {
    
    @StateObject var vm = ViewModel()
    
    // Gradiente usado para preencher a área do gráfico
    let linearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.red.opacity(0.7),
            Color.red.opacity(0.2)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Propriedades computadas para determinar os limites (mínimo e máximo) do eixo X
    var dataMin: Date {
        vm.bpms.compactMap { $0.data }
            .min()
            .map { Date(timeIntervalSince1970: TimeInterval($0) / 1000) } ?? Date()
    }
    
    var dataMax: Date {
        vm.bpms.compactMap { $0.data }
            .max()
            .map { Date(timeIntervalSince1970: TimeInterval($0) / 1000) } ?? Date()
    }
    
    var body: some View {
        VStack {
            Chart {
                // Linha do gráfico
                ForEach(
                    vm.bpms.compactMap { bpm -> (id: String, date: Date, bat: Int)? in
                        // Garante que batimento e data não sejam nulos
                        guard let bat = bpm.batimento, let time = bpm.data else {
                            print("Dados inválidos para bpm com id: \(bpm.id)")
                            return nil
                        }
                        // Converter timestamp para Date (divisão por 1000 se os dados estiverem em milissegundos)
                        return (id: bpm.id,
                                date: Date(timeIntervalSince1970: TimeInterval(time) / 1000),
                                bat: bat)
                    },
                    id: \.id
                ) { item in
                    LineMark(
                        x: .value("Horário", item.date),
                        y: .value("Batimentos", item.bat)
                    )
                    .foregroundStyle(.black)
                }
                .interpolationMethod(.cardinal)
                
                // Área preenchida abaixo da linha
                ForEach(
                    vm.bpms.compactMap { bpm -> (id: String, date: Date, bat: Int)? in
                        guard let bat = bpm.batimento, let time = bpm.data else {
                            print("Dados inválidos para bpm com id: \(bpm.id)")
                            return nil
                        }
                        return (id: bpm.id,
                                date: Date(timeIntervalSince1970: TimeInterval(time) / 1000),
                                bat: bat)
                    },
                    id: \.id
                ) { item in
                    AreaMark(
                        x: .value("Horário", item.date),
                        y: .value("Batimentos", item.bat)
                    )
                    .foregroundStyle(linearGradient)
                }
                .interpolationMethod(.cardinal)
            }
            // Configura o domínio do eixo X de acordo com os dados
            .chartXScale(domain: dataMin...dataMax)
            .chartLegend(.hidden)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                    AxisGridLine()
                    AxisTick()
                    // Formata a data usando o DateFormatter definido
                    if let date = value.as(Date.self) {
                        AxisValueLabel(formater.string(from: date))
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
        .onReceive(timer, perform: { _ in
            print("updating")
            vm.fetch()
        })
    }
}


public var formater: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}()

let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

struct telaGrafico: View {
    @StateObject var vm = ViewModel()
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack{
            GradientAreaChartExampleView()
            
            ScrollView {
                ForEach(vm.bpms.sorted(by: { ($0.data ?? 0) > ($1.data ?? 0) })) { batida in
                    let epochTime = TimeInterval(batida.data!) / 1000
                    let date = Date(timeIntervalSince1970: epochTime)
                    
                    VStack {
                        HStack {
                            Text("Batimentos: \(batida.batimento!)")
                                .font(.headline)
                                .padding(.leading)
                            Spacer()
                            Text("🫀") // Símbolo do coração anatômico
                                .font(.system(size: 40))
                                .scaleEffect(scale)
                                .padding(.trailing)
                                .onAppear {
                                    withAnimation(
                                        Animation.easeInOut(duration: 0.6)
                                            .repeatForever(autoreverses: true)
                                    ) {
                                        scale = 1.2
                                    }
                                }
                        }
                        
                        HStack {
                            Text("Horário: \(date, formatter: formater)")
                                .font(.subheadline)
                                .bold()
                                .padding(.leading)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding([.top, .horizontal])
                }
            }
            .onReceive(timer, perform: { _ in
                print("updating")
                vm.fetch()
            })
        }
        
    }
}

#Preview {
    telaGrafico()
}
