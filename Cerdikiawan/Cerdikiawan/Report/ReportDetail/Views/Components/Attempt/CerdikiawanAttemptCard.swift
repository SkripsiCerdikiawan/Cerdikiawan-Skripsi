//
//  CerdikiawanAttemptCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanAttemptCard: View {
    var date: Date
    var kosakataPercentage: Int
    var idePokokPercentage: Int
    var implisitPercentage: Int
    
    var buttonStyle: CerdikiawanButtonStyle
    var onTapButtonAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "calendar")
                    .imageScale(.medium)
                    .foregroundStyle(Color(.gray))
                
                VStack(alignment: .leading) {
                    Text("Tanggal pengerjaan")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                    Text(DateUtils.getDate(date))
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(DateUtils.getTime(date))
                        .font(.headline)
                }
            }
            
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle")
                    .imageScale(.medium)
                    .foregroundStyle(Color(.gray))
                
                VStack(alignment: .leading) {
                    Text("Status pengerjaan")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Kosakata")
                            Spacer()
                            Text("\(kosakataPercentage)%")
                        }
                        HStack {
                            Text("Ide Pokok")
                            Spacer()
                            Text("\(idePokokPercentage)%")
                        }
                        HStack {
                            Text("Implisit")
                            Spacer()
                            Text("\(implisitPercentage)%")
                        }
                    }
                    .padding(.trailing, 8)
                }
            }
            
            CerdikiawanButton(
                style: buttonStyle,
                label: buttonStyle == .primary ? "Putar Rekaman" : "Hentikan",
                action: {
                    onTapButtonAction()
                }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.cWhite))
        )
        .animation(.easeInOut(duration: 0.2), value: buttonStyle)
    }
}

#Preview {
    @Previewable
    @State var isPlaying: Bool = false
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        CerdikiawanAttemptCard(
            date: Date.now,
            kosakataPercentage: 100,
            idePokokPercentage: 90,
            implisitPercentage: 95,
            buttonStyle: isPlaying ? .secondary : .primary,
            onTapButtonAction: {
                isPlaying.toggle()
            }
        )
        .padding(.horizontal, 16)
    }
}
