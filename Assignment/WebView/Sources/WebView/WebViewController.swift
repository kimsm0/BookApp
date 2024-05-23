/**
 @class WebViewViewController
 @date 4/27/24
 @writer kimsoomin
 @brief
 @update history
 -
 */
import UIKit
import ArchitectureModule
import Extensions
import CustomUI
import WebKit
import Common
import WebViewCommon

// MARK: ViewController에서 구현해야할 프로토콜들
// Router -> ViewController
protocol WebViewViewControllable: ViewControllable {
    
}

// Interator -> ViewController
protocol WebViewPresentable: Presentable {
    var interactor: WebViewInteractableForPresenter? { get set }
    func loadWebView(type: WebViewType)
    func showAlert(message: String)
    func showToast(message: String)
}




final class WebViewController: UIViewController, WebViewPresentable, WebViewViewControllable {

    weak var interactor: WebViewInteractableForPresenter?
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .defaultFont
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    var wkWebView: WKWebView? = nil
    var urlRequest: URLRequest?
    
    //MARK: view life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        config.userContentController = userContentController
        config.processPool = CommonProcessPool.instance.getProcessPool()
        wkWebView = WKWebView(frame: .zero, configuration: config)
        wkWebView?.accessibilityIdentifier = "webviewController_webview"
        wkWebView?.translatesAutoresizingMaskIntoConstraints = false
        wkWebView?.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if AppStore
        
        #else
        if #available(iOS 16.4, *) {
            wkWebView?.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        #endif
                                                
        self.attribute()
        self.layout()
        self.setupProgressView()
        self.setupEstimatedProgressObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.progressView.removeFromSuperview()
    }
    
    @inlinable
    func attribute(){
        self.view.backgroundColor = .defaultBg
    }
    
    @inlinable
    func layout(){
        guard let webView = wkWebView else { return }
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc
    private func didTapBackButton() {
        interactor?.didTapBackButton()
    }
    
    func loadWebView(type: WebViewType) {
        self.setupNavigationItem(left: .dismiss(.back, self, #selector(didTapBackButton)),
                                 right: nil,
                                 title: type.contentType.title)
        
        if let url = URL(string: type.url){
            self.urlRequest = URLRequest(url: url)
        }
        
        guard let webView = wkWebView else { return }
        guard let request = urlRequest else { return }
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsLinkPreview = false
        webView.load(request)
    }
}


extension WebViewController: WKNavigationDelegate{
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
        UIView.animate(withDuration: 0.33,
                               animations: {
                                   self.progressView.alpha = 0.0
                               },
                       completion: { isFinished in
            self.progressView.isHidden = isFinished
        })
    }
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        if progressView.isHidden {
            progressView.isHidden = false
        }
                
        UIView.animate(withDuration: 0.33,
                               animations: {
            self.progressView.alpha = 1.0
        })
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        printLog(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        printLog(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        self.showAlert(message: message, confirmTitle: "확인",cancelTitle: "취소", confirmAction: {
            completionHandler(true)
        }, cancelAction: {
            completionHandler(false)
        })
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Swift.Void) {

        self.showAlert(message: message, confirmTitle: "확인", confirmAction: completionHandler)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        printLog(nil)
    }
}
extension WebViewController: WKUIDelegate { }


extension WebViewController {
    private func setupProgressView() {
        guard let navigationBar = navigationController?.navigationBar else {
            printLog("NavigationBar nil")
            return
        }
        progressView.isHidden = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = wkWebView?.observe(\.estimatedProgress,
                                                        options: [.new]) { [weak self] webView, _ in
            guard let weakSelf = self else { return }
            weakSelf.progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

extension WebViewController {
    func showAlert(message: String) {
        showAlert(message: message, confirmTitle: "확인")
    }
    
    func showToast(message: String) {
        Toast.showToast(message: message)
    }
}
