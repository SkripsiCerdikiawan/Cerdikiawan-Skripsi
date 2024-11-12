//
//  DebugPrint.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

func debugPrint(_ string: String) {
    #if DEBUG
    Swift.debugPrint(string)
    #endif
}
