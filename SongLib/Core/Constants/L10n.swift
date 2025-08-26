//
//  L10n.swift
//  SongLib
//
//  Created by Siro Daves on 24/08/2025.
//

struct L10n {
    static let later = "Later"
    static let cancel = "Cancel"
    static let okay = "Okay"
    static let featureLocked = "This feature is locked"
    static let featureLockedDesc = "Subscribe to SongLib PRO to use this feature among others. Subscribing to PRO supports the developer of this app. Thank you."
    static func featureLockedDescXtra(feature: String) -> String {
        return "Subscribe to SongLib PRO to \(feature)"
    }
    
    static func likedSong(for song: String, isLiked: Bool) -> String {
        if isLiked {
            return "\(song) added to your likes"
        } else {
            return "\(song) removed from your likes"
        }
    }
    
    static let resetDataAlert = "Reset Data?"
    static let resetDataAlertDesc = "Are you sure you want to reset all your data? This action cannot be undone."
    static let joinPro = "Join SongLib Pro"
    static let joinProDesc = "Join SongLib Pro, Exprience advanced search, lots of exclusive features as a way to support the developer of SongLib"
    static let leaveReview = "Leave us a review"
    static let leaveReviewDesc = "You can leave us a review so that others can find this app easily"
    static let resetData = "Reset Data."
    static let resetDataDesc = "You can clear all the data and do the selection afresh."
    static let contactUs = "Contact Us"
    static let contactUsDesc = "In case you have compliment/comoplaints, email us. Don't fail to attach as many screenshots as you can."
}
