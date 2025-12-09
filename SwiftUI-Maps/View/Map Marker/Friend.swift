//
//  Friend.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let place: String
    let imageURL: URL  // asset link
}

// Friends list
let sampleFriends: [Friend] = [
    Friend(
        name: "Alice",
        coordinate: CLLocationCoordinate2D(latitude: 40.752726, longitude: -73.977229),
        place: "Grand Central Terminal",
        imageURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQelhbRRZeBvRyVX3x_P5tB5m93bXX-gb-FpA&s")!
    ),
    Friend(
        name: "Bob",
        coordinate: CLLocationCoordinate2D(latitude: 40.759896, longitude: -73.984130),
        place: "Times Square",
        imageURL: URL(string: "https://static.vecteezy.com/system/resources/previews/048/216/761/non_2x/modern-male-avatar-with-black-hair-and-hoodie-illustration-free-png.png")!
    ),
    Friend(
        name: "Charlie",
        coordinate: CLLocationCoordinate2D(latitude: 40.706192, longitude: -74.009160),
        place: "Wall Street",
        imageURL: URL(string: "https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174669.jpg?semt=ais_hybrid&w=740&q=80")!
    ),
    Friend(
        name: "Daisy",
        coordinate: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242),
        place: "East Village",
        imageURL: URL(string: "https://img.freepik.com/free-vector/smiling-woman-with-braided-hair_1308-177228.jpg?semt=ais_hybrid&w=740&q=80")!
    ),
    Friend(
        name: "Ethan",
        coordinate: CLLocationCoordinate2D(latitude: 40.741062, longitude: -73.989708),
        place: "Flatiron Building",
        imageURL: URL(string: "https://static.vecteezy.com/system/resources/thumbnails/048/216/761/small_2x/modern-male-avatar-with-black-hair-and-hoodie-illustration-free-png.png")!
    ),
    Friend(
        name: "Fiona",
        coordinate: CLLocationCoordinate2D(latitude: 40.748817, longitude: -73.985428),
        place: "Empire State",
        imageURL: URL(string: "https://img.freepik.com/premium-vector/serious-caucasian-woman-with-trendy-bob-haircut-semi-flat-vector-character-head-editable-cartoon-avatar-icon-face-emotion-colorful-spot-illustration-web-graphic-design-animation_151150-16189.jpg")!
    ),
    Friend(
        name: "George",
        coordinate: CLLocationCoordinate2D(latitude: 40.706086, longitude: -73.996864),
        place: "Brooklyn Bridge",
        imageURL: URL(string: "https://img.freepik.com/premium-photo/memoji-emoji-handsome-smiling-man-white-background_826801-6987.jpg?semt=ais_hybrid&w=740&q=80")!
    ),
    Friend(
        name: "Hannah",
        coordinate: CLLocationCoordinate2D(latitude: 40.773565, longitude: -73.956555),
        place: "Upper East Side",
        imageURL: URL(string: "https://img.freepik.com/free-vector/smiling-woman-with-black-hair_1308-171452.jpg?semt=ais_hybrid&w=740&q=80")!
    ),
    Friend(
        name: "Ivan",
        coordinate: CLLocationCoordinate2D(latitude: 40.650002, longitude: -73.949997),
        place: "Brooklyn",
        imageURL: URL(string: "https://png.pngtree.com/png-vector/20250517/ourlarge/pngtree-cartoon-illustration-of-male-avatar-icon-wearing-a-brown-hoodie-jacket-vector-png-image_16306502.png")!
    ),
    Friend(
        name: "Julia",
        coordinate: CLLocationCoordinate2D(latitude: 40.807536, longitude: -73.962573),
        place: "Columbia University",
        imageURL: URL(string: "https://img.freepik.com/free-vector/confident-woman-with-curly-hair_1308-174956.jpg?semt=ais_hybrid&w=740&q=80")!
    )
]

