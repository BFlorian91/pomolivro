//
//  ContentView.swift
//  pomolivro
//
//  Created by Florian Beaumont on 04/04/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomoModel: PomoModel
    var body: some View {
        Home()
            .environmentObject(pomoModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
