//
//  CerdikiawanReadingTypeRowCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanReadingTypeRowCard: View {
    var style: CerdikiawanReadingTypeRowCardStyle = .middle
    
    var title: String
    var desc: String
    var value: Int
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(desc)
                        .font(.caption)
                }
                .padding(.trailing, 8)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(value)%")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .padding(.leading, 8)
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .background(style.backgroundColor)
        .clipShape(style.cornerConfiguration)
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack(spacing: 2) {
            CerdikiawanReadingTypeRowCard(
                style: .top,
                title: "Ide Pokok",
                desc: "Kemampuan untuk memahami ide pokok dari sebuah bacaan",
                value: 10
            )
            CerdikiawanReadingTypeRowCard(
                style: .middle,
                title: "Kosakata",
                desc: "Kemampuan pemahaman anak di bidang kosakata",
                value: 100
            )
            CerdikiawanReadingTypeRowCard(
                style: .bottom,
                title: "Implisit",
                desc: "Kemampuan untuk memahami makna implisit dari sebuah bacaan",
                value: 100
            )
        }
        .padding(16)
    }
}
