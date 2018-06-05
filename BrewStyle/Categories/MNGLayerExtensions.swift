//
//  MNGLayerExtensions.swift
//  
//
//  Created by Tommie N. Carter, Jr., MBA on 6/21/15.
//  Copyright © 2015 MING Technology. All rights reserved.
//
//  Sample usage:  self.view.layer.configureGradientBackground(UIColor.purpleColor().CGColor, UIColor.blueColor().CGColor, UIColor.whiteColor().CGColor)
//  Nota Bene: Function can be applied to any UIControl that also has a view.layer property. Resolves the issue of gradient not covering full area on rotation by resizing the layer to a square

import QuartzCore

extension CALayer {

    //creates a gradient background with varidac arguments
    func configureGradientBackground(colors:CGColorRef...){

        let gradient = CAGradientLayer()

        let maxWidth = max(self.bounds.size.height,self.bounds.size.width)
        let squareFrame = CGRect(origin: self.bounds.origin, size: CGSizeMake(maxWidth, maxWidth))
        gradient.frame = squareFrame

        gradient.colors = colors

        self.insertSublayer(gradient, atIndex: 0)
    }
    
}

