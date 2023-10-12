//
//  Extensions.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

// MARK: Data Request
extension DataRequest {
    
    /// T type olarak bir webservis donusumu uygular.
    func fetchServiceWithErrorHandling<T: BaseResponse>(_ completionHandler: @escaping (_ result: WsResult<T>) -> ()) {
        responseObject{ (response: DataResponse<T>) in
            switch response.result {
            case .success(let mResponse):
                if mResponse.success == "True" {
                    completionHandler(WsResult.success(mResponse))
                } else {
                    completionHandler(WsResult.failure(WsError(mResponse.error ?? "")))
                }
            case .failure(let error):
                completionHandler(WsResult.failure(WsError(error.localizedDescription)))
            }
        }
    }
    
}

// MARK: UIViewController
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    /// Ekrana bir id ile isaretlenmis progress view koyar.
    func presentLoadingView(xPosition: CGFloat = CGFloat(0), yPosition: CGFloat = CGFloat(0)) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let loadingImageView = UIImageView()
            loadingImageView.tag = 123456789
            let loadingResource = "spinner"
            var loadingGif = UIImage()
            
            if let path = Bundle.main.path(forResource: loadingResource, ofType: "gif") {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                   let image = UIImage.gif(data: data) {
                    loadingGif = image
                }
            }
            
            loadingImageView.image = loadingGif
            loadingImageView.backgroundColor = UIColor.clear
            loadingImageView.contentMode = .scaleAspectFit
            
            self.view.addSubview(loadingImageView)
            loadingImageView.translatesAutoresizingMaskIntoConstraints = false
            loadingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            loadingImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            loadingImageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
            loadingImageView.heightAnchor.constraint(equalToConstant: 96).isActive = true
            
            self.view.bringSubviewToFront(loadingImageView)
        }
    }

    /// Ekrana basilmis progressi kaldirir.
    func dismissLoadingView() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let tagId = 63476788
        let cover = self.view.viewWithTag(tagId)
        cover?.removeFromSuperview()
        for view in self.view.subviews {
            if let loadingImageView = view.viewWithTag(123456789) {
                loadingImageView.removeFromSuperview()
            }
        }
        self.view.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
}

// MARK: UIImage
extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }

    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }
    
}
