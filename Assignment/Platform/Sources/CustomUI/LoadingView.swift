/**
 @class LoadingView
 @date
 @writer kimsoomin
 @brief 최상위에 indicator 뷰 노출/숨김 처리 
 @update history
 -
 */

import UIKit

public class LoadingView {
    public static func showLoading() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            if let keyWindow = windowScene?.windows.filter({$0.isKeyWindow}).first {
                let loadingIndicatorView: UIActivityIndicatorView
                if let existedView = keyWindow.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                    loadingIndicatorView = existedView
                } else {
                    loadingIndicatorView = UIActivityIndicatorView(style: .large)
                    loadingIndicatorView.frame = keyWindow.frame
                    loadingIndicatorView.color = .brown
                    keyWindow.addSubview(loadingIndicatorView)
                }
                loadingIndicatorView.startAnimating()
            }
        }
    }

    public static func hideLoading() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            if let keyWindow = windowScene?.windows.filter({$0.isKeyWindow}).first {
                keyWindow.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
            }
        }        
    }
}
