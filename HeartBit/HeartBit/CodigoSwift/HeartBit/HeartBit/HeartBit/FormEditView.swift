import SwiftUI

struct FormEditView: View {
    @State private var name = ""
    @State private var cpf = ""
    @State private var rg = ""
    @State private var phone = ""
    @State private var naturalidade = ""
    @State private var birthDate = Date()
    @State private var address = ""
    @State private var neighborhood = ""
    @State private var city = ""
    @State private var postalCode = ""
    @State private var state = ""
    @State private var susCard = ""
    @State private var healthPlan = ""
    @State private var bloodType = ""
    @State private var doctorName = ""
    @State private var doctorPhone = ""
    @State private var emergencyContacts: [Contatos] = [Contatos(nome: "", email: "")]
    @State private var medicalHistory = ""
    @State private var isAllergic = false
    @State private var allergyDetails = ""
    @State private var hasSeizures = false
    @State private var seizureDetails = ""
    @State private var feverMedication = ""
    @State private var surgeryDone = false
    @State private var surgeryDetails = ""
    @State private var healthIssues: [String: Bool] = [
        "Problema Renal": false,
        "Disritmia": false,
        "Hipoglicemia": false,
        "Hiperglicemia": false,
        "Problemas cardíacos": false,
        "Enxaqueca": false,
        "Diabetes": false,
        "Hipertensão": false,
        "Asma": false,
        "Epilepsia": false,
        "Rinite": false,
        "Úlcera": false,
        "Sonambulismo": false,
        "Sangramento nasal": false,
        "Dificuldade de cicatrização": false
    ]
    
    @State private var showSaveAlert = false
    
    @ObservedObject var vm = ViewModel()
    
    @MainActor
    var body: some View {
        ZStack {
            Color.backgroundColor1.ignoresSafeArea()
            VStack{
                Text("Ficha Médica")
                    .font(.title)
                    .bold()
                NavigationView {
                    Form {
                        personalSection
                        contactSection
                        healthPlanSection
                        doctorSection
                        emergencySection
                        historySection
                        issuesSection
                        
                        Section {
                            Button(action: {
                                showSaveAlert = true
                                saveForm()
                                let id = vm.formulariounico?._id
                                let rev = vm.formulariounico?._rev

                                    let newFormData = newFormData(
                                        _id: id!,
                                        _rev: rev!,
                                        name: name,
                                        cpf: cpf,
                                        rg: rg,
                                        phone: phone,
                                        naturalidade: naturalidade,
                                        address: address,
                                        neighborhood: neighborhood,
                                        city: city,
                                        postalCode: postalCode,
                                        state: state,
                                        susCard: susCard,
                                        healthPlan: healthPlan,
                                        bloodType: bloodType,
                                        doctorName: doctorName,
                                        doctorPhone: doctorPhone,
                                        emergencyContacts: emergencyContacts,
                                        medicalHistory: medicalHistory,
                                        allergyDetails: allergyDetails,
                                        seizureDetails: seizureDetails,
                                        feverMedication: feverMedication,
                                        surgeryDetails: surgeryDetails,
                                        isAllergic: isAllergic,
                                        hasSeizures: hasSeizures,
                                        surgeryDone: surgeryDone,
                                        birthDate: birthDate,
                                        healthIssues: healthIssues
                                    )
                                    
                                    Task {
                                        let url = URL(string: "http://192.168.128.8:1880/putformteste")!
                                        do {
                                            try await vm.putForm(url: url, newFormData: newFormData)
                                            print("Formulário enviado com sucesso.")
                                        } catch {
                                            print("Erro ao enviar o formulário: \(error.localizedDescription)")
                                        }
                                    }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Salvar")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.vermelhoRed)
                                .cornerRadius(8)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.backgroundColor1)
                    .alert("Dados salvos com sucesso!", isPresented: $showSaveAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }.onAppear{vm.fetchForm()}
            }
            Spacer()
        }
    }
    
    
    var personalSection: some View {
        Section(header: Text("Informações Pessoais").font(.headline).foregroundColor(.black)) {
            VStack(spacing: 15) {
                TextField("Nome", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("CPF", text: $cpf)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("RG", text: $rg)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Data de Nascimento", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                
                TextField("Naturalidade", text: $naturalidade)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.vertical, 10)
        }
        .listRowBackground(Color.white)
    }
    
    var contactSection: some View {
        Section(header: Text("Contato e Endereço").font(.headline).foregroundColor(.black)) {
            VStack(spacing: 15) {
                TextField("Telefone", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Endereço", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Bairro", text: $neighborhood)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Cidade", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("CEP", text: $postalCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Estado", text: $state)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.vertical, 10)
        }
        .listRowBackground(Color.white)
    }
    
    var healthPlanSection: some View {
        Section(header: Text("Plano de Saúde").font(.headline).foregroundColor(.black)) {
            VStack(spacing: 15) {
                TextField("Cartão SUS", text: $susCard)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Plano de Saúde", text: $healthPlan)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Tipo Sanguíneo", text: $bloodType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.vertical, 10)
        }
        .listRowBackground(Color.white)
    }
    
    var doctorSection: some View {
        Section(header: Text("Médico").font(.headline).foregroundColor(.black)) {
            VStack(spacing: 15) {
                TextField("Nome do Médico", text: $doctorName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Telefone do Médico", text: $doctorPhone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.vertical, 10)
        }
        .listRowBackground(Color.white)
    }
    
    var emergencySection: some View {
        Section(header: Text("Contatos de Emergência")
            .font(.headline)
            .foregroundColor(.black)) {
            
            VStack(spacing: 20) {
                ForEach(emergencyContacts.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Nome/Parentesco", text: $emergencyContacts[index].nome)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Email", text: $emergencyContacts[index].email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .padding(.vertical, 10)
        }
        .listRowBackground(Color.white)
    }

    
    var historySection: some View {
        Section(header: Text("Histórico Médico").font(.headline).foregroundColor(.black)) {
            VStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Observações médicas:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextEditor(text: $medicalHistory)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                Toggle("É alérgico a medicamento?", isOn: $isAllergic)
                if isAllergic {
                    TextField("Qual medicamento?", text: $allergyDetails)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Toggle("Já teve ou tem convulsão?", isOn: $hasSeizures)
                if hasSeizures {
                    TextField("Detalhes da convulsão", text: $seizureDetails)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                TextField("Em caso de febre, o que costuma tomar?", text: $feverMedication)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Toggle("Já fez cirurgia?", isOn: $surgeryDone)
                if surgeryDone {
                    TextField("Detalhes da cirurgia", text: $surgeryDetails)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.vertical, 10)
        }
        .listRowBackground(Color.white)
    }
    
    var issuesSection: some View {
        Section(header: Text("Problemas de Saúde").font(.headline).foregroundColor(.black)) {
            VStack(spacing: 10) {
                ForEach(healthIssues.keys.sorted(), id: \.self) { issue in
                    Toggle(issue, isOn: Binding(
                        get: { healthIssues[issue] ?? false },
                        set: { healthIssues[issue] = $0 }
                    ))
                }
            }
            .padding(.vertical, 10)
        }
        .listRowBackground(Color.white)
    }
    
    func saveForm() {
        let formData = FormData(
            name: name, cpf: cpf, rg: rg, phone: phone, naturalidade: naturalidade,
            address: address, neighborhood: neighborhood, city: city, postalCode: postalCode, state: state,
            susCard: susCard, healthPlan: healthPlan, bloodType: bloodType,
            doctorName: doctorName, doctorPhone: doctorPhone, emergencyContacts: emergencyContacts,
            medicalHistory: medicalHistory, allergyDetails: allergyDetails, seizureDetails: seizureDetails,
            feverMedication: feverMedication, surgeryDetails: surgeryDetails,
            isAllergic: isAllergic, hasSeizures: hasSeizures, surgeryDone: surgeryDone,
            birthDate: birthDate, healthIssues: healthIssues
        )

        if let data = try? JSONEncoder().encode(formData) {
            UserDefaults.standard.set(data, forKey: "formData")
        }
    }
    func loadForm() {
        if let data = UserDefaults.standard.data(forKey: "formData"),
           let savedData = try? JSONDecoder().decode(FormData.self, from: data) {
            name = savedData.name
            cpf = savedData.cpf
            rg = savedData.rg
            phone = savedData.phone
            naturalidade = savedData.naturalidade
            address = savedData.address
            neighborhood = savedData.neighborhood
            city = savedData.city
            postalCode = savedData.postalCode
            state = savedData.state
            susCard = savedData.susCard
            healthPlan = savedData.healthPlan
            bloodType = savedData.bloodType
            doctorName = savedData.doctorName
            doctorPhone = savedData.doctorPhone
            emergencyContacts = savedData.emergencyContacts
            medicalHistory = savedData.medicalHistory
            isAllergic = savedData.isAllergic
            allergyDetails = savedData.allergyDetails
            hasSeizures = savedData.hasSeizures
            seizureDetails = savedData.seizureDetails
            feverMedication = savedData.feverMedication
            surgeryDone = savedData.surgeryDone
            surgeryDetails = savedData.surgeryDetails
            birthDate = savedData.birthDate
            healthIssues = savedData.healthIssues
        }
    }
}
struct FormData: Codable {
    let name, cpf, rg, phone, naturalidade, address, neighborhood, city, postalCode, state: String
    let susCard, healthPlan, bloodType, doctorName, doctorPhone: String
    let emergencyContacts: [Contatos]
    let medicalHistory, allergyDetails, seizureDetails, feverMedication, surgeryDetails: String
    let isAllergic, hasSeizures, surgeryDone: Bool
    let birthDate: Date
    let healthIssues: [String: Bool]
}

struct Contatos : Codable{
    var nome : String
    var email : String
}


#Preview {
    FormEditView()
}
