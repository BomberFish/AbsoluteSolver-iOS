import Exploit

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

public enum AbsoluteSolver {
    public static func replace(at: URL, with: NSData) throws {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: at.path)
            let owner = fileAttributes[.ownerAccountName] as? String ?? "unknown"
            if owner == "root" {
                // Do not show to Apple employees.
                // They will NOT like it.
                if MDC.isMDCSafe {
                    print("[AbsoluteSolver] Using MDC method for file \(at.path)")
                    let success = MDC.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
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
            } else if owner == "mobile" {
                print("[AbsoluteSolver] Using FM method for file \(at.path)")
                do {
                    let success = with.write(to: at, atomically: true)
                    if !success {
                        print("[AbsoluteSolver] FM overwrite failed!")
                        // Haptic.shared.notify(.error)
                        throw "AbsoluteSolver: Error replacing file at \(at.path) Using unsandboxed FileManager"
                    } else {
                        print("[AbsoluteSolver] FM overwrite success!")
                        // Haptic.shared.notify(.success)
                    }
                } catch {
                    throw "AbsoluteSolver: Error replacing file at \(at.path) \n\(error.localizedDescription)"
                }
            } else if owner == "unknown" {
                print("[AbsoluteSolver] Error: Could not find owner for file \(at.path)?!")
                // Haptic.shared.notify(.error)
                throw "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nCould not find owner?!"
            } else {
                print("[AbsoluteSolver] Warning: Unexpected owner for file \(at.path)! Using MDC...")
                // Haptic.shared.notify(.error)
                // throw "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nUnexpected file owner!"
                let success = MDC.overwriteFileWithDataImpl(originPath: at.path, replacementData: Data(with))
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

    // chainsaw hand time
    public static func delete(at: URL) throws {
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
                    try FileManager.default.removeItem(at: at)
                    print("[AbsoluteSolver] FM delete success!")
                    // Haptic.shared.notify(.success)
                } catch {
                    throw "Error deleting file at \(at.path) (Edit Style: AbsoluteSolver)\n\(error.localizedDescription)"
                }
            } else if owner == "unknown" {
                print("[AbsoluteSolver] Error: Could not find owner for file \(at.path)?!")
                // Haptic.shared.notify(.error)
                throw "AbsoluteSolver: Error deleting file at \(at.path)\nCould not find owner?!"
            } else {
                print("[AbsoluteSolver] Error: Unexpected owner for file \(at.path)!")
                // Haptic.shared.notify(.error)
                throw "AbsoluteSolver: Error deleting file at \(at.path)\nUnexpected file owner!"
            }
        } catch {
            print("[AbsoluteSolver] Error deleting file \(at.path): \(error.localizedDescription)")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error deleting file at \(at.path)\n\(error.localizedDescription)"
        }
    }

    public static func copy(at: URL, to: URL) throws {
        do {
            do {
                try FileManager.default.copyItem(at: at, to: to)
            } catch {
                throw "AbsoluteSolver: Cannot copy file \(to.path) to \(at.path): \(error.localizedDescription)"
            }

        } catch {
            print("[AbsoluteSolver] Error: \(error.localizedDescription)")
            // Haptic.shared.notify(.error)
            throw "AbsoluteSolver: Error replacing file at \(at.path)\n\(error.localizedDescription)"
        }
    }

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
                print("Deleting \(file)")
                do {
                    try delete(at: URL(fileURLWithPath: path).appendingPathComponent(file))
                    currentfile += 1
                    progress((Double(currentfile / contents.count), file))
                } catch {
                    throw "\(error.localizedDescription)"
                }
            }
        } catch {
            throw "AbsoluteSolver: Error deleting the contents of \(path): \(error.localizedDescription)"
        }
    }
    
    
    public enum MDC {
        public static var isMDCSafe: Bool = true

        // MARK: - Literally black magic.

        public static func overwriteFileWithDataImpl(originPath: String, replacementData: Data) -> Bool {
            // open and map original font
            let fd = open(originPath, O_RDONLY | O_CLOEXEC)
            if fd == -1 {
                print("Could not open target file")
                return false
            }
            defer { close(fd) }
            // check size of font
            let originalFileSize = lseek(fd, 0, SEEK_END)
            guard originalFileSize >= replacementData.count else {
                print("Original file: \(originalFileSize)")
                print("Replacement file: \(replacementData.count)")
                print("File too big!")
                return false
            }
            lseek(fd, 0, SEEK_SET)

            // Map the font we want to overwrite so we can mlock it
            let fileMap = mmap(nil, replacementData.count, PROT_READ, MAP_SHARED, fd, 0)
            if fileMap == MAP_FAILED {
                print("Failed to map")
                return false
            }
            // mlock so the file gets cached in memory
            guard mlock(fileMap, replacementData.count) == 0 else {
                print("Failed to mlock")
                return true
            }

            // for every 16k chunk, rewrite
            print(Date())
            for chunkOff in stride(from: 0, to: replacementData.count, by: 0x4000) {
                print(String(format: "%lx", chunkOff))
                let dataChunk = replacementData[chunkOff..<min(replacementData.count, chunkOff + 0x4000)]
                var overwroteOne = false
                for _ in 0..<2 {
                    let overwriteSucceeded = dataChunk.withUnsafeBytes { dataChunkBytes in
                        unaligned_copy_switch_race(
                            fd, Int64(chunkOff), dataChunkBytes.baseAddress, dataChunkBytes.count
                        )
                    }
                    if overwriteSucceeded {
                        overwroteOne = true
                        print("Successfully overwrote!")
                        break
                    }
                    print("try again?!")
                }
                guard overwroteOne else {
                    print("Failed to overwrite")
                    return false
                }
            }
            print(Date())
            print("Successfully overwrote!")
            return true
        }

        public static func xpc_crash(_ serviceName: String) {
            let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: serviceName.utf8.count)
            defer { buffer.deallocate() }
            strcpy(buffer, serviceName)
            xpc_crasher(buffer)
        }

        public static func unsandbox() throws {
            var errormessage = ""
            if #available(iOS 16.2, *) {
                throw "Your device is incompatible"
            } else if #available(macOS 13.1, *) {
                throw "Your device is incompatible"
            } else {
                grant_full_disk_access { error in
                    if error != nil {
                        errormessage = String(describing: error?.localizedDescription ?? "unknown?!")
                    }
                }

                if errormessage != "" {
                    throw errormessage
                }
            }
        }
    }
}
