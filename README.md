# HorizontalList

[![Version](https://img.shields.io/cocoapods/v/HorizontalList.svg?style=flat)](https://cocoapods.org/pods/HorizontalList)
[![License](https://img.shields.io/cocoapods/l/HorizontalList.svg?style=flat)](https://cocoapods.org/pods/HorizontalList)
[![Platform](https://img.shields.io/cocoapods/p/HorizontalList.svg?style=flat)](https://cocoapods.org/pods/HorizontalList)

## HorizontalList

HorizontalList is an efficient SwiftUI horizontal ScrollView which loads only visible elements. HorizontalList subviews could be different size. 

![gif demo](https://github.com/DistilleryTech/HorizontalList/blob/master/demo.gif)

## Usage

```swift
var body: some View {
    HorizontalList(0...100000) { index in
        Text("\(index)").padding(10)
    }
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

HorizontalList is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HorizontalList'
```
