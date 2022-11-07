//
//  FileManagerService.swift
//  protectedPhotos
//
//  Created by 1234 on 06.09.2022.
//

import Foundation


struct Content {
    let url: URL
    let lastPath: String
    let fileType: FileType
    let data: Data?

    enum FileType: String {
        case folder = "NSFileTypeDirectory"
        case file = "NSFileTypeRegular"
    }
}

protocol FileManagerServiceProtocol {
    var documentsUrl: URL {get}

    func contentsOfDirectory(url: URL?) -> Result<[Content], Error>
    func createDirectory(url: URL?)
    func createFile(file: Data, url: URL)
    func removeContent(url: URL)
    func getData(with url: URL) -> Data?
}


final class FileManagerService: FileManagerServiceProtocol {

    private let fileManager = FileManager.default
    var documentsUrl: URL { getDocumentsUrl() }

    func contentsOfDirectory(url: URL?) -> Result<[Content], Error> {
        var result: [Content] = []
        let currentUrl = url ?? getDocumentsUrl()
        do {
            let contents = try fileManager.contentsOfDirectory(at: currentUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for content in contents {
                do {
                    let attributes = try fileManager.attributesOfItem(atPath: content.path)
                    let lastPath = content.lastPathComponent
                    if let fileTypeString = attributes[FileAttributeKey.type] as? String {
                        let fileType: Content.FileType = (fileTypeString == Content.FileType.folder.rawValue) ? .folder : .file
                        let data = try? Data(contentsOf: content)
                        result.append(Content(url: content, lastPath: lastPath, fileType: fileType, data: data))
                    }
                } catch let error {
                    return .failure(error)
                }
            }
        } catch let error {
            return .failure(error)
        }
        return .success(result)
    }

    func createDirectory(url: URL?) {
        guard let url = url else { return }
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        print("Create folder \(url.lastPathComponent)")
    }

    func createFile(file: Data, url: URL) {
        var result: Bool?
        result = fileManager.createFile(atPath: url.path, contents: file, attributes: nil)
        if let _ = result {
            print("Create file successful")
        } else {
            print("File not created")
        }
    }

    func removeContent(url: URL) {
        try? fileManager.removeItem(at: url)
        print("Remove content")
    }

    func getData(with url: URL) -> Data? {
        var savedData: Data?
        do {
         // Get the saved data
            savedData = try Data(contentsOf: url)
        } catch {
         // Catch any errors
            print("Unable to read the file")
        }
        return savedData
    }

    private func getDocumentsUrl() -> URL {
        try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}
