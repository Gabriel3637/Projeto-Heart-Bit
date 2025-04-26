//
//  ContentView.swift
//  project
//
//  Created by Turma01-7 on 03/04/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.backgroundColor1.withAlphaComponent(10)
        UITabBar.appearance().unselectedItemTintColor = UIColor.vermelhoRed
    }



    
    var body: some View {
        TabView{
            HeartBitView()
                .tabItem {
        Image(systemName: "heart.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
         Text("HeartBit")
                }
        CalcIMCView()
                .tabItem {
                    Image(systemName: "scalemass.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                     Text("IMC")
                }
            FormEditView()
                .tabItem{
                    Image(systemName: "list.bullet.clipboard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                     Text("Ficha Médica")
                }
                
        }.accentColor(.black)
        .background(Color.backgroundColor1)
    }
}


#Preview {
    ContentView()
}
