//
//  PhotoDownloadVC.swift
//  ExampleProject
//
//  Created by Abdur Rahim on 8/5/19.
//  Copyright © 2019 Abdur Rahim. All rights reserved.
//

import UIKit
let dataSourceURL = URL(string:"https://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")!
class PhotoDownloadVC: UIViewController {
    var photos: [PhotoRecord] = []
    let pendingOperations = PendingOperations()
    
    @IBOutlet weak var photoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhotoDetails()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPhotoDetails() {
        let request = URLRequest(url: dataSourceURL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            let alertController = UIAlertController(title: "Oops!", message: "There was an error fetching photo details.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            if let data = data {
                do {
                    let datasourceDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String: String]
                    for (name, value) in datasourceDictionary {
                        let valx = value.replacingOccurrences(of: "http", with: "https")
                        let url = URL(string: valx)
                        if let url = url {
                            let photoRecord = PhotoRecord(name: name, url: url)
                            self.photos.append(photoRecord)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.photoTable.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }

   

}
extension PhotoDownloadVC:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell?.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell?.accessoryView = indicator
        }
        let indicator = cell?.accessoryView as! UIActivityIndicatorView
        
        //2
        let photoDetails = photos[indexPath.row]
        
        //3
        cell?.textLabel?.text = photoDetails.name
        cell?.imageView?.image = photoDetails.image
        
        //4
        switch (photoDetails.state) {
        case .filtered:
            indicator.stopAnimating()
        case .failed:
            indicator.stopAnimating()
            cell?.textLabel?.text = "Failed to load"
        case .new, .downloaded:
            indicator.startAnimating()
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: photoDetails, at: indexPath)
            }
        }
        
        return cell!
    }
    
 func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //1
        suspendAllOperations()
    }
    
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    // MARK: - operation management
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filtrationQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells() {
        //1
        if let pathsArray = photoTable.indexPathsForVisibleRows {
            //2
            var allPendingOperations = Set(pendingOperations.downloadsInPreogress.keys)
            allPendingOperations.formUnion(pendingOperations.filtrationInProgress.keys)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInPreogress[indexPath] {
                    pendingDownload.cancel()
                }
                
                pendingOperations.downloadsInPreogress.removeValue(forKey: indexPath)
                if let pendingFiltration = pendingOperations.filtrationInProgress[indexPath] {
                    pendingFiltration.cancel()
                }
                
                pendingOperations.filtrationInProgress.removeValue(forKey: indexPath)
            }
            
            // 6
            for indexPath in toBeStarted {
                let recordToProcess = photos[indexPath.row]
                startOperations(for: recordToProcess, at: indexPath)
            }
        }
    }
    
    func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        switch (photoRecord.state) {
        case .new:
            startDownload(for: photoRecord, at: indexPath)
        case .downloaded:
            startFiltration(for: photoRecord, at: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        //1
        guard pendingOperations.filtrationInProgress[indexPath] == nil else {
            return
        }
        
        //2
        let downloader = ImageDownloader(photoRecord)
        //3
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.filtrationInProgress.removeValue(forKey: indexPath)
                self.photoTable.reloadRows(at: [indexPath], with: .fade)
            }
        }
        //4
        pendingOperations.downloadsInPreogress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltration(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        guard pendingOperations.filtrationInProgress[indexPath] == nil else {
            return
        }
        
        let filterer = ImageFiltration(photoRecord)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.filtrationInProgress.removeValue(forKey: indexPath)
                self.photoTable.reloadRows(at: [indexPath], with: .fade)
            }
        }
        
        pendingOperations.filtrationInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
    
}
