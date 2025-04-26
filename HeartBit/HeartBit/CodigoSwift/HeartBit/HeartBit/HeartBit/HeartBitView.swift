import SwiftUI
import CoreLocation


    struct HeartBitView: View {
        @State private var showAlert = false
        @State private var isButtonEnabled = true
        @State private var timeRemaining = 5
        @State private var timerRunning = false
        @State private var showSheetCall = false
        
        @StateObject var vm = ViewModel()
        @State var em = Testeemail()
        @State private var bat = 0
        @State private var locationDataManager = LocationManager()
         

        @State private var latitude: Double = 0
        @State private var longitude: Double = 0
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        let tempo2 = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        
        @State var valorAnt = 0;
        @State var busca = false;
        
        var body: some View {
            NavigationStack{
                ZStack {
                    Color(.backgroundColor1).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Button(action: {
                            resetTimer()
                            showAlert = true
                            timerRunning = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                if showAlert {
                                    resetTimer()
                                    showAlert = false
                                    showSheetCall = true
                                }
                            }
                        }) {
                            Image(.heart)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 15)
                                )
                                .shadow(radius: 10)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Alerta de Emergência"),
                                message: Text("Emergência detectada.\nTempo restante: \(timeRemaining) segundos"),
                                dismissButton: .default(Text("CANCELAR"))
                            )
                        }
                        
                        Text("\(vm.bpms.first?.batimento ?? 0) BPMs")
                            .padding(.top, 30)
                            .font(.title)
                        
                        NavigationLink(destination: telaGrafico()){
                            Text("Acesse o Gráfico")
                                .padding([.top, .bottom], 10)
                                .padding([.leading, .trailing], 60)
                                .foregroundColor(.white)
                                .background(Color.vermelhoRed)
                                .cornerRadius(30)
                                .font(.title)
                        }
                        .padding([.top, .bottom], 30)
                        
                    }
                    .sheet(isPresented: $showSheetCall) {
                        sheetView()
                    }
                }
                .onAppear(){
                    let yourLatitudeString = String(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")
                    let yourLongitudeString = String(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")
                    self.latitude = (Double(yourLatitudeString) ?? 0)
                    self.longitude =  (Double(yourLongitudeString) ?? 0)
                    
                    vm.fetchForm()
                    
                }
                .onReceive(tempo2){_ in
                    print("updating, busca: \(busca)")
                    if(vm.bpms.count > 1){
                        valorAnt = vm.bpms[0].batimento!
                    }
                    vm.fetch()
                    
                    busca = true
                    let yourLatitudeString = String(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")
                    let yourLongitudeString = String(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")
                    self.latitude = (Double(yourLatitudeString) ?? 0)
                    self.longitude =  (Double(yourLongitudeString) ?? 0)
                    print("\(latitude)")
                }
                .onReceive(timer) { _ in
                    if timeRemaining > 0 && timerRunning {
                        timeRemaining -= 1
                    }
                }.onChange(of: valorAnt){
                    if(vm.bpms.count > 1){
                        if(Float(vm.bpms[0].batimento!) > Float(vm.bpms[1].batimento!)*1.3){
                                print("maior")
                            resetTimer()
                            
                            showAlert = true
                            timerRunning = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                
                                if showAlert {
                                    print("enviou \(latitude)")
                                    em.sendEmail(formulario: vm.formulariounico!, latitude: latitude, longitude: longitude)
                                    resetTimer()
                                    showAlert = false
                                    showSheetCall = true
                                }
                                
                            }
                        }else if(Float(vm.bpms[0].batimento!) < Float(vm.bpms[1].batimento!)*0.7){
                                print("menor")
                            resetTimer()
                            //vm.fetchForm()
                            showAlert = true
                            timerRunning = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                
                                if showAlert {
                                    print("enviou \(latitude)")
                                    em.sendEmail(formulario: vm.formulariounico!, latitude: latitude, longitude: longitude)
                                    resetTimer()
                                    showAlert = false
                                    showSheetCall = true
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        func resetTimer() {
            timeRemaining = 5
            timerRunning = true
        }
    }

    struct sheetView: View{
        @State private var offset: CGFloat = 0
        var body: some View{
            ZStack {
                Color(.backgroundColor1).edgesIgnoringSafeArea(.all)
                VStack{
                    Image(systemName: "message.badge.filled.fill.rtl")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.vermelhoRed)
                        .frame(width: 100, height: 100)
                        .offset(x: offset)
                        .onAppear {
                            withAnimation(
                                Animation.linear(duration: 0.1)
                                    .repeatForever(autoreverses: true)
                            ) {
                                offset = 10
                            }
                        }
                    
                    Text("Mensagem de Emergência Enviada")
                        .font(.largeTitle)
                        .foregroundColor(.vermelhoRed)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                }
            }
        }
    }

    #Preview {
        HeartBitView()
    }
