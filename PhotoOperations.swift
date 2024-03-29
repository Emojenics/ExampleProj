//
//  PhotoOperations.swift
//  ExampleProject
//
//  Created by Abdur Rahim on 8/4/19.
//  Copyright © 2019 Abdur Rahim. All rights reserved.
//

import UIKit
//This enum contains all the possible states a photo recordcan be in
enum PhotoRecordState
{
    case new, downloaded, filtered, failed
}
class PhotoRecord
{
    let name: String
    let url: URL
    var state = PhotoRecordState.new
    var image = UIImage(named: "placeholder")
    
    init(name:String,url:URL)
    {
        self.name = name
        self.url = url
    }
    
    
}
class  PendingOperations
{
    lazy var downloadsInPreogress:[IndexPath:Operation] = [:]
    lazy var downloadQueue:OperationQueue =
        {
            var queue = OperationQueue()
            queue.name = "Download queue"
            queue.maxConcurrentOperationCount = 1
            return queue
    }()
    lazy var filtrationInProgress:[IndexPath:Operation] = [:]
    lazy var filtrationQueue:OperationQueue =
        {
            var queue = OperationQueue()
            queue.name = "Image Filteration queue"
            queue.maxConcurrentOperationCount = 1
            return queue
    }()
    
}
class ImageDownloader : Operation
{
    let photoRecord:PhotoRecord
    init(_ photoRecord:PhotoRecord)
    {
        self.photoRecord = photoRecord
    }
    override func main() {
        if isCancelled
        {
            return
        }
        guard let imageData = try? Data(contentsOf: photoRecord.url)
            else{
                return
        }
        if (isCancelled)
        {
            return
        }
        if !imageData.isEmpty
        {
        photoRecord.image = UIImage(data: imageData)
            photoRecord.state = .downloaded
        }
        else
        {
            photoRecord.state = .failed
            photoRecord.image = UIImage(named: "Failed")
        }
    }
}

class ImageFiltration: Operation
{
    let photoRecord:PhotoRecord
     init(_ photoRecord: PhotoRecord)
    {
     self.photoRecord = photoRecord
    }
    override func main() {
        if isCancelled
        {
            return
        }
        guard self.photoRecord.state == .downloaded
        else
        {
            return
        }
        if let image = photoRecord.image, let filteredImage = applySepiaFilter(image)
        {
            photoRecord.image = filteredImage
            photoRecord.state = .filtered
        }
        
    }
    func applySepiaFilter(_ image: UIImage) -> UIImage?
    {
        guard let data = UIImagePNGRepresentation(image)
        else
        {
            return nil
        }
        let inputImage = CIImage(data: data)
        if isCancelled
        {
            return nil
        }
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CISepiaTone")
            else{
                return nil
        }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "InputIntensity")
        guard let outputImage = filter.outputImage, let outimage = context.createCGImage(outputImage, from: outputImage.extent)
            else
        {
            return nil
        }
        return UIImage(cgImage: outimage)
    }
}

