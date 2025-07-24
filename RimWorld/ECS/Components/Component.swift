//
//  Component.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

/// 协议 Component
import Foundation

protocol Component: Encodable {
    func bindEntityID(_ bindEntityID: Int)
}






