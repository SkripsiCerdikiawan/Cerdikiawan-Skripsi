//
//  CerdikiawanResultData.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

struct CerdikiawanResultData: View {
    var result: ResultDataEntity
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ResultMediumBoxContainer(
                    label: "Jawaban Benar",
                    value: result.correctCount,
                    valueTextColor: Color(.cDarkBlue)
                )
                ResultMediumBoxContainer(
                    label: "Jawaban Salah",
                    value: result.inCorrectCount,
                    valueTextColor: Color(.cDarkRed)
                )
            }
            
            ResultScoreBoxContainer(result: result)
            ResultGainedBalanceBox(result: result)
        }
    }
}

private struct ResultMediumBoxContainer: View {
    var label: String
    var value: Int
    var valueTextColor: Color = .primary
    
    var body: some View {
        VStack {
            VStack {
                Text("\(value)")
                    .foregroundStyle(valueTextColor)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(label)
                    .font(.footnote)
                
            }
            .padding(.vertical, 32)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.cWhite))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

private struct ResultScoreBoxContainer: View {
    var result: ResultDataEntity
    @State var value: CGFloat = 0
    @State var style: CerdikiawanScoreStyle = .normal
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(Int(value))%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(style.foregroundPrimaryColor)
                    Text("Skor didapatkan")
                }
                
                Spacer()
                
                VStack {
                    CerdikiawanPieBar(
                        value: calculatePercentage()
                    )
                }
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.cWhite))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .onAppear() {
            value = calculatePercentage()
            style = CerdikiawanScoreStyle.determineStyle(value: Int(value))
        }
    }
    
    func calculatePercentage() -> CGFloat {
        return CGFloat((Double(result.correctCount) / Double(result.totalQuestions)) * 100)
    }
}

private struct ResultGainedBalanceBox: View {
    var result: ResultDataEntity
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "dollarsign.square.fill")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(Color(.cLightBlue))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Kamu mendapatkan")
                    Text("\(Int(result.baseBalance * result.correctCount)) poin")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.cDarkBlue))
                }

            }
            .padding(32)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.cWhite))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        CerdikiawanResultData(
            result: .init(
                correctCount: 5,
                inCorrectCount: 3,
                totalQuestions: 10,
                baseBalance: 5,
                storyId: "story-1",
                kosakataPercentage: 1,
                idePokokPercentage: 1,
                implisitPercentage: 1,
                recordSoundData: Data()
            )
        )
        .padding(.horizontal, 16)
    }
}
