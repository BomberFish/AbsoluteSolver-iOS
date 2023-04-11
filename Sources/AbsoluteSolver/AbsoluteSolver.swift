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
    
    public static func replace(at: URL, with: NSData) throws {
        do {
            print("[AbsoluteSolver] Replacing \(at.path)! X)")
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: at.path)
            let owner = fileAttributes[.ownerAccountName] as? String ?? "unknown"
            if owner == "root" {
                // Do not show to Apple employees.
                // They will NOT like it.
                if MacDirtyCow.isMDCSafe {
                    print("[AbsoluteSolver] Using MDC method for file \(at.path)")
                    let success = MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
                    if !success {
                        print("[AbsoluteSolver] MDC overwrite failed! X(")
                        // Haptic.shared.notify(.error)
                        throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC)"
                    } else {
                        print("[AbsoluteSolver] MDC overwrite success! X)")
                        // Haptic.shared.notify(.success)
                    }
                } else {
                    // you cant get ram out of thin air
                    // also prevents catastrophic failure and corruption 👍👍👍
                    print("[AbsoluteSolver] PANIC!!! OUT OF RAM!!! THIS IS REALLY REALLY REALLY BAD!!!!!")
                    // Haptic.shared.notify(.error)
                    throw "AbsoluteSolver:\n Overwrite failed!\nInsufficient RAM! Please reopen the app."
                }
            } else if owner == "mobile" {
                print("[AbsoluteSolver] Using FM method for file \(at.path)")
                do {
                    let success = with.write(to: at, atomically: true)
                    if !success {
                        print("[AbsoluteSolver] FM overwrite failed! X(")
                        // Haptic.shared.notify(.error)
                        throw "AbsoluteSolver: Error replacing file at \(at.path) (Using unsandboxed FileManager)"
                    } else {
                        print("[AbsoluteSolver] FM overwrite success! X)")
                        // Haptic.shared.notify(.success)
                    }
                } catch {
                    print("[AbsoluteSolver] Warning: FM overwrite failed, using MDC for \(at.path): \(error.localizedDescription)")
                    if MacDirtyCow.isMDCSafe {
                        print("[AbsoluteSolver] Using MDC method for file \(at.path)")
                        let success = MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
                        if !success {
                            print("[AbsoluteSolver] MDC overwrite failed")
                            // Haptic.shared.notify(.error)
                            throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC)"
                        } else {
                            print("[AbsoluteSolver] MDC overwrite success!")
                            // Haptic.shared.notify(.success)
                        }
                    } else {
                        // you cant get ram out of thin air
                        // also prevents catastrophic failure and corruption 👍👍👍
                        print("[AbsoluteSolver] PANIC!!! OUT OF RAM!!! THIS IS REALLY REALLY REALLY BAD!!!!!")
                        // Haptic.shared.notify(.error)
                        throw "AbsoluteSolver: Overwrite failed!\nInsufficient RAM! Please reopen the app."
                    }
                }
            } else if owner == "unknown" {
                print("[AbsoluteSolver] Error: Could not find owner for file \(at.path)?!")
                // Haptic.shared.notify(.error)
                throw "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nCould not find owner?!"
            } else {
                print("[AbsoluteSolver] Warning: Unexpected owner for file \(at.path)! Using MDC...")
                // Haptic.shared.notify(.error)
                // throw "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nUnexpected file owner!"
                let success = MacDirtyCow.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
                if !success {
                    print("[AbsoluteSolver] MDC overwrite failed")
                    // Haptic.shared.notify(.error)
                    throw "AbsoluteSolver: Error replacing file at \(at.path) (Using MDC)"
                } else {
                    print("[AbsoluteSolver] MDC overwrite success!")
                    // Haptic.shared.notify(.success)
                }
            }
        } catch {
            print("[AbsoluteSolver] Error: \(error.localizedDescription)")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error replacing file at \(at.path)\n\(error.localizedDescription)"
        }
    }

    // MARK: - Delete files
    // chainsaw hand time
    public static func delete(at: URL) throws {
        print("[AbsoluteSolver] Disassembling \(at.path)! X)")
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: at.path)
            let owner = fileAttributes[.ownerAccountName] as? String ?? "unknown"
            if owner == "root" {
                print("[AbsoluteSolver] Skipping file \(at.path), owned by root")
//                print("[AbsoluteSolver] Using MDC method")
//                do {
//                    try MDCModify.delete(at: at)
//                } catch {
//                    throw "Error deleting file at \(at.path) (Edit Style: AbsoluteSolver)\n\(error.localizedDescription)"
//                }
            } else if owner == "mobile" {
                print("[AbsoluteSolver] Using FM method for file \(at.path)")
                do {
                    //destroy file with this sick as hell railgun
                    try FileManager.default.removeItem(at: at)
                    print("[AbsoluteSolver] FM delete success!")
                    // Haptic.shared.notify(.success)
                } catch {
                    throw "Error disassembling file at \(at.path) (Edit Style: AbsoluteSolver)\n\(error.localizedDescription)"
                }
            } else if owner == "unknown" {
                print("[AbsoluteSolver] Error: Could not find owner for file \(at.path)?!")
                // Haptic.shared.notify(.error)
                throw "AbsoluteSolver: Error disassembling file at \(at.path)\nCould not find owner?!"
            } else {
                print("[AbsoluteSolver] Error: Unexpected owner for file \(at.path)!")
                // Haptic.shared.notify(.error)
                throw "AbsoluteSolver: Error disassembling file at \(at.path)\nUnexpected file owner!"
            }
        } catch {
            print("[AbsoluteSolver] Error disassembling file \(at.path): \(error.localizedDescription)")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error disassembling file at \(at.path)\n\(error.localizedDescription)"
        }
    }
    
    // MARK: - copy files
    
    public static func copy(at: URL, to: URL) throws {
        do {
            do {
                try FileManager.default.copyItem(at: at, to: to)
            } catch {
                print("AbsoluteSolver: Cannot copy file \(to.path) to \(at.path): \(error.localizedDescription). X(")
                throw "AbsoluteSolver: Cannot copy file \(to.path) to \(at.path): \(error.localizedDescription)"
            }

        } catch {
            print("[AbsoluteSolver] Error: \(error.localizedDescription). X(")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error replacing file at \(at.path)\n\(error.localizedDescription)"
        }
    }

    // MARK: - reads file contents
    
    public static func readFile(path: String) throws -> Data {
        do {
            return (try Data(contentsOf: URL(fileURLWithPath: path)))
        } catch {
//            do {
//                print("[AbsoluteSolver] Warning: Swift read failed for file \(path)! Using ObjC read...")
//                return try AbsoluteSolver_ObjCHelper().readRawDataFromFile(atPath: path)!
//            } catch {
//                throw "AbsoluteSolver: Error reading from file \(path): \(error.localizedDescription)"
//            }
            print("AbsoluteSolver: Error reading from file \(path): \(error.localizedDescription). X(")
            throw "AbsoluteSolver: Error reading from file \(path): \(error.localizedDescription)"
        }
    }

    // MARK: - deletes all the contents of directories. usually.

    public static func delDirectoryContents(path: String, progress: ((Double, String)) -> ()) throws {
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
            print( "AbsoluteSolver: Error disassembling the contents of \(path): \(error.localizedDescription)! X(")
            throw "AbsoluteSolver: Error disassembling the contents of \(path): \(error.localizedDescription)"
        }
    }
    
    // MARK: - Plist padding
    
    public static func padPlist(replacementData: Data, filePath: String) throws -> Data? {
            guard let currentData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
            if replacementData.count == currentData.count { return replacementData }
            
            print("[AbsoluteSolver] Using new plist padding method! X)")
            var data = replacementData
            let trailerData = Array(data.suffix(32))
            var offsetTableOffset = trailerData[24..<32].withUnsafeBytes {
                $0.load(as: UInt64.self).bigEndian
            }
            //  print("og count: \(data.count)")
            if trailerData[0] == 170 && trailerData[1] == 170 {
                let amountOfPaddingBytes = trailerData[2..<6]
                var amountOfPadding = 0
                for byte in amountOfPaddingBytes {
                    amountOfPadding = amountOfPadding << 8
                    amountOfPadding = amountOfPadding | Int(byte)
                }
        //    print("padding digits: \(amountOfPadding)")
                offsetTableOffset = offsetTableOffset - UInt64(amountOfPadding)

                data =
                    data[0..<Int(offsetTableOffset)]
                        + data[(Int(offsetTableOffset) + amountOfPadding)..<data.count]
        //    print("count after padding removal: \(data.count)")
            }

            if data.count > currentData.count {
                print("[AbsoluteSolver] Using old plist padding method! X)")
                guard let Default_Data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
                if replacementData.count == Default_Data.count { return replacementData }
                print("pd.count", replacementData.count, "dd.count", Default_Data.count)
                guard let Plist = try? PropertyListSerialization.propertyList(from: replacementData, format: nil) as? [String: Any] else { return nil }
                var EditedDict = Plist
                guard var newData = try? PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0) else { return nil }
                var count = 0
                print("DefaultData - " + String(Default_Data.count))
                while true {
                    newData = try! PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0)
                    if newData.count >= Default_Data.count { break }
                    count += 1
                    EditedDict.updateValue(String(repeating: "*", count: Int(floor(Double(count/2)))), forKey: "0")
                    EditedDict.updateValue(String(repeating: "+", count: count - Int(floor(Double(count/2)))), forKey: "MdC")
                }
                print("ImportData - " + String(newData.count))
                return newData
            }

            let amountOfBytesBeingAdded = currentData.count - data.count
            let amountOfBytesBeingAddedAs4Bytes = withUnsafeBytes(
                of: Int32(amountOfBytesBeingAdded).bigEndian, Array.init)

            var newData = data[0..<Int(offsetTableOffset)]
            //  print("added \(newData.count) bytes - original data upto offsetTable")

            newData += Data(repeating: 0xAA, count: amountOfBytesBeingAdded)
            //  print("added \(amountOfBytesBeingAdded) bytes of padding...")

            let beingAddedOffsetPositions = data[Int(offsetTableOffset)..<data.count - 32]
            newData += beingAddedOffsetPositions
            //  print("added \(beingAddedOffsetPositions) bytes - offset table")

            newData += Data(repeating: 0xAA, count: 2)
            newData += Data(amountOfBytesBeingAddedAs4Bytes)
            newData += Data(trailerData[6..<24])
            newData += withUnsafeBytes(
                of: (Int(offsetTableOffset) + amountOfBytesBeingAdded).bigEndian, Array.init)

            //  print(newData)

            guard let _ = try? PropertyListSerialization.propertyList(from: newData, options: [], format: nil)
            else {
                print("[AbsoluteSolver] Using old plist padding method! X)")
                guard let Default_Data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
                if replacementData.count == Default_Data.count { return replacementData }
                print("pd.count", replacementData.count, "dd.count", Default_Data.count)
                guard let Plist = try? PropertyListSerialization.propertyList(from: replacementData, format: nil) as? [String: Any] else { return nil }
                var EditedDict = Plist
                guard var newData = try? PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0) else { return nil }
                var count = 0
                print("DefaultData - " + String(Default_Data.count))
                while true {
                    newData = try! PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0)
                    if newData.count >= Default_Data.count { break }
                    count += 1
                    EditedDict.updateValue(String(repeating: "*", count: Int(floor(Double(count/2)))), forKey: "0")
                    EditedDict.updateValue(String(repeating: "+", count: count - Int(floor(Double(count/2)))), forKey: "MdC")
                }
                print("ImportData - " + String(newData.count))
                return newData
            }
            return newData
    }
}
