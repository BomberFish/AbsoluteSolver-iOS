//
//  AbsoluteSolver.swift
//
//
//  Created by Hariz Shirazi on 2023-04-09.
//  Copyright © J.C. Jensen in Spaaaaace!!!!. Some rights reserved.
//

import Foundation
import MacDirtyCow

public enum AbsoluteSolver {
    
    // MARK: - Replace file
    
    public static func replace(at: URL, with: NSData, progress: ((String)) -> () = {message in
        print(message)
    }) throws {
        // In case the specified path is empty
        if at == URL(string: "") {
            throw "AbsoluteSolver Error: Can I get a location?"
        }
        
        do {
            progress("[AbsoluteSolver] Replacing \(at.path)! X)")
            var fm_error: String? = nil
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: at.path)
            let owner = fileAttributes[.ownerAccountName] as? String ?? "unknown"
            if owner == "root" {
                // Do not show to Apple employees.
                // They will NOT like it.
                if MacDirtyCow.isMDCSafe {
                    progress("[AbsoluteSolver] Using MDC method for file \(at.path)")
                    do {
                        try MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
                        progress("[AbsoluteSolver] MDC overwrite success! X)")
                    } catch {
                        progress("[AbsoluteSolver] MDC overwrite failed! X(")
                        throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC): \(error.localizedDescription)"
                    }
//                    if !success {
//                        progress("[AbsoluteSolver] MDC overwrite failed! X(")
//                        // Haptic.shared.notify(.error)
//                        throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC)"
//                    } else {
//                        progress("[AbsoluteSolver] MDC overwrite success! X)")
//                        // Haptic.shared.notify(.success)
//                    }
                } else {
                    // you cant get ram out of thin air
                    // also prevents catastrophic failure and corruption 👍👍👍
                    progress("[AbsoluteSolver] PANIC!!! OUT OF RAM!!! THIS IS REALLY REALLY REALLY BAD!!!!!")
                    // Haptic.shared.notify(.error)
                    throw "AbsoluteSolver:\n Overwrite failed!\nInsufficient RAM! Please reopen the app."
                }
            } else if owner == "mobile" {
                progress("[AbsoluteSolver] Using FM method for file \(at.path)")
                do {
                    try with.write(to: at, options: .atomic)
                    progress("[AbsoluteSolver] FM overwrite success! X)")
                } catch {
                    // print("[AbsoluteSolver] FM overwrite failed! X(")
                    fm_error = error.localizedDescription
                    progress("[AbsoluteSolver] Warning: FM overwrite failed, using MDC for \(at.path). Error: \(fm_error ?? "Unknown")")
                    if MacDirtyCow.isMDCSafe {
                        progress("[AbsoluteSolver] Using MDC method for file \(at.path)")
                        // let success = MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
                        do {
                            try MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
                            progress("[AbsoluteSolver] MDC overwrite success! X)")
                        } catch {
                            progress("[AbsoluteSolver] MDC overwrite failed! X(")
                            if fm_error != nil {
                                throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC): \(error.localizedDescription). Unsandboxed FileManager returned error: \(fm_error ?? "Unknown")"
                            } else {
                                throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC): \(error.localizedDescription)"
                            }
                        }
//                        if !success {
//                            progress("[AbsoluteSolver] MDC overwrite failed")
//                            // Haptic.shared.notify(.error)
//                            if fm_error != nil {
//                                throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC). Unsandboxed FileManager returned error: \(fm_error ?? "Unknown")"
//                            } else {
//                                throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC)"
//                            }
//                        } else {
//                            progress("[AbsoluteSolver] MDC overwrite success!")
//                            // Haptic.shared.notify(.success)
//                        }
                    } else {
                        // you cant get ram out of thin air
                        // also prevents catastrophic failure and corruption 👍👍👍
                        progress("[AbsoluteSolver] PANIC!!! OUT OF RAM!!! THIS IS REALLY REALLY REALLY BAD!!!!!")
                        // Haptic.shared.notify(.error)
                        throw "AbsoluteSolver: Guru Meditation: Insufficient RAM! Please reopen the app."
                    }
                }
            } else if owner == "unknown" {
                progress("[AbsoluteSolver] Error: Could not find owner for file \(at.path)?!")
                // Haptic.shared.notify(.error)
                throw "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nCould not find owner?!"
            } else {
                progress("[AbsoluteSolver] Warning: Unexpected owner for file \(at.path)! Using MDC...")
                // Haptic.shared.notify(.error)
                // throw "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nUnexpected file owner!"
                do {
                    try MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
                    progress("[AbsoluteSolver] MDC overwrite success! X)")
                } catch {
                    progress("[AbsoluteSolver] MDC overwrite failed! X(")
                    throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC): \(error.localizedDescription)"
                }
//                let success = MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
//                if !success {
//                    progress("[AbsoluteSolver] MDC overwrite failed")
//                    // Haptic.shared.notify(.error)
//                    throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC)"
//                } else {
//                    progress("[AbsoluteSolver] MDC overwrite success!")
//                    // Haptic.shared.notify(.success)
//                }
            }
        } catch {
            progress("[AbsoluteSolver] Error: \(error.localizedDescription)")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error replacing file at \(at.path)\n\(error.localizedDescription)"
        }
    }

    // MARK: - Delete files
    // chainsaw hand time
    public static func delete(at: URL, progress: ((String)) -> () = {progress in
        print(progress)
    }) throws {
        // In case the specified path is empty
        if at == URL(string: "") {
            throw "AbsoluteSolver Error: Can I get a location?"
        }
        progress("[AbsoluteSolver] Disassembling \(at.path)! X)")
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: at.path)
            let owner = fileAttributes[.ownerAccountName] as? String ?? "unknown"
            if owner == "root" {
                progress("[AbsoluteSolver] Skipping file \(at.path), owned by root")
//                progress("[AbsoluteSolver] Using MDC method")
//                do {
//                    try MDCModify.delete(at: at)
//                } catch {
//                    throw "Error deleting file at \(at.path) (Edit Style: AbsoluteSolver)\n\(error.localizedDescription)"
//                }
            } else if owner == "mobile" {
                progress("[AbsoluteSolver] Using FM method for file \(at.path)")
                do {
                    //destroy file with this sick as hell railgun
                    try FileManager.default.removeItem(at: at)
                    progress("[AbsoluteSolver] FM delete success!")
                    // Haptic.shared.notify(.success)
                } catch {
                    throw "Error disassembling file at \(at.path) (Edit Style: AbsoluteSolver)\n\(error.localizedDescription)"
                }
            } else if owner == "unknown" {
                progress("[AbsoluteSolver] Error: Could not find owner for file \(at.path)?!")
                // Haptic.shared.notify(.error)
                throw "AbsoluteSolver: Error disassembling file at \(at.path)\nCould not find owner?!"
            } else {
                progress("[AbsoluteSolver] Error: Unexpected owner for file \(at.path)!")
                // Haptic.shared.notify(.error)
                throw "AbsoluteSolver: Error disassembling file at \(at.path)\nUnexpected file owner!"
            }
        } catch {
            progress("[AbsoluteSolver] Error disassembling file \(at.path): \(error.localizedDescription)")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error disassembling file at \(at.path)\n\(error.localizedDescription)"
        }
    }
    
    // MARK: - copy files
    
    public static func copy(at: URL, to: URL, progress: ((String)) -> () = {progress in
        print(progress)
    }) throws {
        // In case the specified path is empty
        if at == URL(string: "") || to == URL(string: "") {
            throw "AbsoluteSolver Error: Can I get a location?"
        }
        do {
            do {
                try FileManager.default.copyItem(at: at, to: to)
            } catch {
                progress("AbsoluteSolver: Cannot copy file \(to.path) to \(at.path): \(error.localizedDescription). X(")
                throw "AbsoluteSolver: Cannot copy file \(to.path) to \(at.path): \(error.localizedDescription)"
            }

        } catch {
            progress("[AbsoluteSolver] Error: \(error.localizedDescription). X(")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error replacing file at \(at.path)\n\(error.localizedDescription)"
        }
    }

    // MARK: - reads file contents
    
    public static func readFile(path: String, progress: ((String)) -> () = {progress in
        print(progress)
    }) throws -> Data {
        progress("[AbsoluteSolver] Reading from \(path)! X)")
        // In case the specified path is empty
        if path == "" {
            progress("[AbsoluteSolver] path is empty? wtf?")
            throw "AbsoluteSolver Error: Can I get a location?"
        }
        do {
            return (try Data(contentsOf: URL(fileURLWithPath: path)))
        } catch {
//            do {
//                progress("[AbsoluteSolver] Warning: Swift read failed for file \(path)! Using ObjC read...")
//                return try AbsoluteSolver_ObjCHelper().readRawDataFromFile(atPath: path)!
//            } catch {
//                throw "AbsoluteSolver: Error reading from file \(path): \(error.localizedDescription)"
//            }
            progress("AbsoluteSolver: Error reading from file \(path): \(error.localizedDescription). X(")
            throw "AbsoluteSolver: Error reading from file \(path): \(error.localizedDescription)"
        }
    }

    // MARK: - deletes all the contents of directories. usually.

    public static func delDirectoryContents(path: String, progress: ((Double, String)) -> ()) throws {
        // In case the specified path is empty
        if path == "" {
            throw "AbsoluteSolver Error: Can I get a location?"
        }
        var contents = [""]
        var currentfile = 0
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: path)
            for file in contents {
                //print("disassembling \(file)")
                do {
                    try delete(at: URL(fileURLWithPath: path).appendingPathComponent(file))
                    currentfile += 1
                    progress((Double(currentfile / contents.count), file))
                } catch {
                    throw "\(error.localizedDescription)"
                }
            }
        } catch {
            progress((0.0, "AbsoluteSolver: Error disassembling the contents of \(path): \(error.localizedDescription)! X("))
            throw "AbsoluteSolver: Error disassembling the contents of \(path): \(error.localizedDescription)"
        }
    }
    
    // MARK: - Plist padding
    
    public static func padPlist(replacementData: Data, filePath: String, progress: ((String)) -> () = {progress in
        print(progress)
    }) throws -> Data? {
        // In case the specified path is empty
        if filePath == "" {
            throw "AbsoluteSolver Error: Can I get a location?"
        }
            guard let currentData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
            if replacementData.count == currentData.count { return replacementData }
            
        progress("[AbsoluteSolver] Using new plist padding method! X)")
            var data = replacementData
            let trailerData = Array(data.suffix(32))
            var offsetTableOffset = trailerData[24..<32].withUnsafeBytes {
                $0.load(as: UInt64.self).bigEndian
            }
            //  progress("og count: \(data.count)")
            if trailerData[0] == 170 && trailerData[1] == 170 {
                let amountOfPaddingBytes = trailerData[2..<6]
                var amountOfPadding = 0
                for byte in amountOfPaddingBytes {
                    amountOfPadding = amountOfPadding << 8
                    amountOfPadding = amountOfPadding | Int(byte)
                }
        //    progress("padding digits: \(amountOfPadding)")
                offsetTableOffset = offsetTableOffset - UInt64(amountOfPadding)

                data =
                    data[0..<Int(offsetTableOffset)]
                        + data[(Int(offsetTableOffset) + amountOfPadding)..<data.count]
        //    progress("count after padding removal: \(data.count)")
            }

            if data.count > currentData.count {
                progress("[AbsoluteSolver] Using old plist padding method! X)")
                guard let Default_Data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
                if replacementData.count == Default_Data.count { return replacementData }
                progress("pd.count " + String(replacementData.count) + ", dd.count " + String(Default_Data.count))
                guard let Plist = try? PropertyListSerialization.propertyList(from: replacementData, format: nil) as? [String: Any] else { return nil }
                var EditedDict = Plist
                guard var newData = try? PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0) else { return nil }
                var count = 0
                progress("DefaultData - " + String(Default_Data.count))
                while true {
                    newData = try! PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0)
                    if newData.count >= Default_Data.count { break }
                    count += 1
                    EditedDict.updateValue(String(repeating: "*", count: Int(floor(Double(count/2)))), forKey: "0")
                    EditedDict.updateValue(String(repeating: "+", count: count - Int(floor(Double(count/2)))), forKey: "MdC")
                }
                progress("ImportData - " + String(newData.count))
                return newData
            }

            let amountOfBytesBeingAdded = currentData.count - data.count
            let amountOfBytesBeingAddedAs4Bytes = withUnsafeBytes(
                of: Int32(amountOfBytesBeingAdded).bigEndian, Array.init)

            var newData = data[0..<Int(offsetTableOffset)]
            //  progress("added \(newData.count) bytes - original data upto offsetTable")

            newData += Data(repeating: 0xAA, count: amountOfBytesBeingAdded)
            //  progress("added \(amountOfBytesBeingAdded) bytes of padding...")

            let beingAddedOffsetPositions = data[Int(offsetTableOffset)..<data.count - 32]
            newData += beingAddedOffsetPositions
            //  progress("added \(beingAddedOffsetPositions) bytes - offset table")

            newData += Data(repeating: 0xAA, count: 2)
            newData += Data(amountOfBytesBeingAddedAs4Bytes)
            newData += Data(trailerData[6..<24])
            newData += withUnsafeBytes(
                of: (Int(offsetTableOffset) + amountOfBytesBeingAdded).bigEndian, Array.init)

            //  progress(newData)

            guard let _ = try? PropertyListSerialization.propertyList(from: newData, options: [], format: nil)
            else {
                progress("[AbsoluteSolver] Using old plist padding method! X)")
                guard let Default_Data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
                if replacementData.count == Default_Data.count { return replacementData }
                progress("pd.count " + String(replacementData.count) + ", dd.count " + String(Default_Data.count))
                guard let Plist = try? PropertyListSerialization.propertyList(from: replacementData, format: nil) as? [String: Any] else { return nil }
                var EditedDict = Plist
                guard var newData = try? PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0) else { return nil }
                var count = 0
                progress("DefaultData - " + String(Default_Data.count))
                while true {
                    newData = try! PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0)
                    if newData.count >= Default_Data.count { break }
                    count += 1
                    EditedDict.updateValue(String(repeating: "*", count: Int(floor(Double(count/2)))), forKey: "0")
                    EditedDict.updateValue(String(repeating: "+", count: count - Int(floor(Double(count/2)))), forKey: "MdC")
                }
                progress("ImportData - " + String(newData.count))
                return newData
            }
            return newData
    }
    
    public static func replaceDDICert() throws {
        let pem: Data = Data(base64Encoded: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMyRENDQWtHZ0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREJlTVFzd0NRWURWUVFHRXdKRFFURUwKTUFrR0ExVUVDQXdDUWtNeEpUQWpCZ05WQkFvTUhFb3VReTRnU21WdWMyVnVJR2x1SUZOd1lXRmhZV0ZqWlNFaApJU0V4R3pBWkJnTlZCQU1NRWtGaWMyOXNkWFJsVTI5c2RtVnlJRVJFU1RBZUZ3MHdOekEwTVRZeU1qVTFNekZhCkZ3MHhOREEwTVRZeU1qVTFNekZhTUY0eEN6QUpCZ05WQkFZVEFrTkJNUXN3Q1FZRFZRUUlEQUpDUXpFbE1DTUcKQTFVRUNnd2NTaTVETGlCS1pXNXpaVzRnYVc0Z1UzQmhZV0ZoWVdObElTRWhJVEViTUJrR0ExVUVBd3dTUVdKegpiMngxZEdWVGIyeDJaWElnUkVSSk1JR2ZNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0R05BRENCaVFLQmdRRE9vWFI3ClE5eVdqVWVxQUEwdCtVZTJUUnR3MG5nc1htdmdhVE9xSWp3Y3E1ZGNZRFdBZU9rdnZ0VGdNUVNHN2VDeVlBclMKQ29RMjVMVXlhRk1LV1NQVG9RUFRscnhhYmRDNXJkRzNqdHBjUXJVUzJJWXZ0d0E0aUE3SkoyL25BUEQ3OWEyWgo5a2VKaEUzbGVKZ1A2N3BnSXBVS2RkRWxPc3ZOT0lhS2g5a3ZYUUlEQVFBQm80R2xNSUdpTUIwR0ExVWREZ1FXCkJCUlk5TE54STJ0MEFRYXBmZFV6bjRaOHNnWjdhVEJ3QmdOVkhTTUVhVEJub1dLa1lEQmVNUXN3Q1FZRFZRUUcKRXdKRFFURUxNQWtHQTFVRUNBd0NRa014SlRBakJnTlZCQW9NSEVvdVF5NGdTbVZ1YzJWdUlHbHVJRk53WVdGaApZV0ZqWlNFaElTRXhHekFaQmdOVkJBTU1Fa0ZpYzI5c2RYUmxVMjlzZG1WeUlFUkVTWUlCQVRBUEJnTlZIUk1CCkFmOEVCVEFEQVFIL01BMEdDU3FHU0liM0RRRUJDd1VBQTRHQkFJbFZVMkN0Q3NtelRhOW1LWlVHYW1FSTBqMDgKOTBDeU9nL1Nqei8wQm1QRkMwTlhGNjI5dUlLVjRoMFV5cjQvVGZWZG01eW5LWG42MWtXMEhjOTR2STh5RnY2YworMlExS0p3TDhOWjgrVm9XNjNoZWlUOGpXbmEvY29BZHJicFZ2SGFhbWgvNkZXbit0YnNtZlg3c1MvYmxaN2Z2CndYRjFBWDZkRk5MUEFVYmoKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=")!
        do {
            try replace(at: URL(fileURLWithPath: "/System/Library/Lockdown/iPhoneDebug.pem"), with: pem as NSData)
        } catch {
            throw error.localizedDescription
        }
    }
}
