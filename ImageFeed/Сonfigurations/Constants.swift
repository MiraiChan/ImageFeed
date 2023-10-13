//
//  Constants.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 25.08.23.
//

import Foundation

//MARK: - DateFormatter

let longDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "d MMMM YYYY"
    return df
}()

