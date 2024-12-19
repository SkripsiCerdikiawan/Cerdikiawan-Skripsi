//
//  CerdikiawanLevelSelectionCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

struct CerdikiawanLevelSelectionCard: View {
    var imageName: String
    var title: String
    var description: String
    var availableBalanceToGain: Int
    var onTapGesture: () -> Void
    
    var body: some View {
        VStack {
            // Image
            Image(uiImage: UIImage(named: imageName) ?? UIImage(imageLiteralResourceName: "NOTFOUND_IMAGE"))
                .resizable()
                .frame(height: 112)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    HStack {
                        Text("Bisa dapat")
                        HStack(spacing: 0) {
                            Image(systemName: "dollarsign.square")
                                .imageScale(.small)
                            Text("\(availableBalanceToGain)")
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .imageScale(.small)
                }
                .foregroundStyle(Color(.cDarkBlue))
                .font(.subheadline)
                .fontWeight(.semibold)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .background(
            Color(.cWhite)
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 8
                    )
                )
        )
        .frame(width: 200)
        .frame(minHeight: 280)
        .onTapGesture {
            onTapGesture()
        }
    }
}

#Preview {
    ZStack {
        Color(ColorResource.cGray).ignoresSafeArea()
        ScrollView(.horizontal) {
            HStack(alignment: .top) {
                CerdikiawanLevelSelectionCard(
                    imageName: "DEBUG_IMAGE",
                    title: "Perjalanan Budi Ke Pasar",
                    description: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                    availableBalanceToGain: 10,
                    onTapGesture: {
                        
                    }
                )
                
                CerdikiawanLevelSelectionCard(
                    imageName: "DEBUG_IMAGE",
                    title: "Perjalanan Budi Ke Pasar",
                    description: "Sunyi House of Coffee di Jakarta memberdayakan difabel dengan lingkungan kerja inklusif dan suportif.",
                    availableBalanceToGain: 10,
                    onTapGesture: {
                        
                    }
                )
                
                CerdikiawanLevelSelectionCard(
                    imageName: "DEBUG_IMAGE",
                    title: "Perjalanan Budi Ke Pasar",
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent congue enim id nibh blandit, et ultricies nunc tempor. Duis sit amet dui iaculis, vestibulum magna nec, lobortis ligula. Fusce faucibus luctus urna, in facilisis nunc rutrum sed. Sed placerat congue quam eget egestas. Donec ac auctor ligula. Etiam eu imperdiet lorem, sit amet laoreet elit. Pellentesque mattis eu turpis at mollis. Aenean vel fermentum arcu, non ultricies sapien. Aliquam luctus leo eu tellus eleifend mollis.",
                    availableBalanceToGain: 10,
                    onTapGesture: {
                        
                    }
                )
            }
        }
        .safeAreaPadding(.horizontal, 16)
        
    }
}
