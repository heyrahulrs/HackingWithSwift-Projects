# Project 13 - Instafilter

## Notes

### 1. CIContext

`CIContext` is a part of CoreImage that handles rendering.

### 2. CIFilter

`CIFilter` is also a part of CoreImage, and stores the selected filter.

### 3. How filters can be chosen?

CIFilter has an `init()` which takes name of the filter as a `String`.

Example: `CIFilter(name: "CISepiaTone")` creates a Sepia Tone CIFilter.

### 4. How to set intensity of a CIFilter?

CIFilter has a method `setValue()` that takes a value as `Any?` and a key as `String`. Key to set Intensity is `kCIInputIntensityKey`.

### 5. Various types of values & keys you can set to a CIFilter

You can set many different values to CIFilter.
But in this project, we used 4 keys:

* **kCIInputIntensityKey** - It sets the filter intensity.
* **kCIInputRadiusKey** - It sets the radius of effect. (Example: Radius of Twirl in CITwirlDistortion)
* **kCIInputScaleKey** - Its sets the amount of the effect.
* **kCIInputCenterKey** - It sets the center of effect. (Example: Center of Twirl in CITwirlDistortion)

Remember, different filters take different values. Example: Not every filter needs a Intensity value.

### 6. How to get Output Image from CIFilter?

CIFilter has a property called `outputImage` which returns image as `CIImage`. You'll need to convert it into a cgImage and then in UIImage.

### 7. How to render image as UIImage?

That's where `CIContext` comes into work. CIContext has a method called `createCGImage()` which takes `CIImage`, and `CGRect` as its parameter.

Then, You will need to convert the returned `CGImage` into `UIImage` using `UIImage(cgImage: cgImage)`

### 8. Save UIImage to Photo Library

You use `UIImageWriteToSavedPhotosAlbum` to save altered image to Photo Library.

> The app will crash if you haven't added `NSPhotoLibraryAddUsageDescription` to your apps Info.plist
