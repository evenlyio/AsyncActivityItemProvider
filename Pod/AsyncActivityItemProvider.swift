//
//  AsyncActivityItemProvider.swift
//  AsyncActivityItemProvider
//
//  Created by Jed Lewison on 7/16/15.
//  Copyright (c) 2015 Magic App Factory. All rights reserved.
//

import UIKit


public typealias ProvideItemHandler = (activityType: String, operation: AsyncActivityItemProviderOperationController) -> ()
public typealias CancellationHandler = (operation: AsyncActivityItemProviderOperationController) -> ()


public enum ProgressControllerMode {
    case Enabled(controllerTitle: String, showingProgress: Bool, cancellable: Bool)
    case Disabled
}


public protocol AsyncActivityItemProviderOperationController: NSObjectProtocol {
    func finishWithItem(item: AnyObject?)
    func finish()
    func cancel()
    var progress: Double { get set }
    var cancelled: Bool { get }
}


final public class AsyncActivityItemProvider {

    let provideItemHandler: ProvideItemHandler
    let cancellationHandler: CancellationHandler?
    let placeholderItem: AnyObject
    let progressControllerMode: ProgressControllerMode

    public init(placeholderItem: AnyObject, provideItemHandler: ProvideItemHandler, cancellationHandler: CancellationHandler? = nil, progressControllerMode: ProgressControllerMode = .Enabled(controllerTitle: "Preparing...", showingProgress: true, cancellable: true)) {
        self.placeholderItem = placeholderItem
        self.provideItemHandler = provideItemHandler
        self.cancellationHandler = cancellationHandler
        self.progressControllerMode = progressControllerMode
    }
}


public extension UIActivityViewController {

    public convenience init(asyncItemProviderOperation: ActivityItemProviderOperation, activityItems: [AnyObject]? = nil, applicationActivities: [UIActivity]? = nil) {
        var allActivityItems: [AnyObject] = [AsyncUIActivityItemProvider(itemProviderOperation: asyncItemProviderOperation)]
        if let activityItems = activityItems {
            allActivityItems.appendContentsOf(activityItems)
        }
        
        self.init(activityItems: allActivityItems, applicationActivities: applicationActivities)
    }

    public convenience init(asyncItemProvider: AsyncActivityItemProvider, activityItems: [AnyObject]? = nil, applicationActivities: [UIActivity]? = nil) {
        var allActivityItems: [AnyObject] = [AsyncUIActivityItemProvider(itemProvider: asyncItemProvider)]
        if let activityItems = activityItems {
            allActivityItems.appendContentsOf(activityItems)
        }

        self.init(activityItems: allActivityItems, applicationActivities: applicationActivities)
    }

}
