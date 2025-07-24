//
//  SerializationUtility.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation

class DataCoder {
    static func encode<T: Encodable>(_ object: T) -> Data {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            return data
        } catch {
            print("Encoding error: \(error)")
            return Data()
        }
    }
    
    static func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
    
    static func encodeEntityComponents(_ entity: RMEntity) -> Data? {
        var bundle = ComponentBundle(components: [:])
        let components = entity.allComponents()
        for component in components{
            let componentType = String(describing: type(of: component))
            if let encoded = try? JSONEncoder().encode(component){
                bundle.components[componentType] = encoded
            }
        }
        
        return try? JSONEncoder().encode(bundle)
    }
    
    static func decodeEntityComponents(_ data: Data) -> [Component] {
        guard let bundle = try? JSONDecoder().decode(ComponentBundle.self, from: data) else {
            return []
        }

        var components: [Component] = []

        for (key, value) in bundle.components {
            if let type = componentTypeMap[key],
               let decoded = try? JSONDecoder().decode(type, from: value) {
                components.append(decoded as! Component)
            }else {
                ECSLogger.log("\(key)：并未在组件映射表中")
            }
        }

        return components
    }

}


struct ComponentBundle: Codable {
    var components: [String: Data]
}
