//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Романов on 19.05.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
