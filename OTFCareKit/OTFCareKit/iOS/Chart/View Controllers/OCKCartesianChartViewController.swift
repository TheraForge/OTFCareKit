/*
 Copyright (c) 2019, Apple Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

 3. Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#if !os(watchOS)

import OTFCareKitUI
import Foundation

open class OCKCartesianChartViewController: OCKChartViewController<OCKCartesianChartController, OCKCartesianChartViewSynchronizer> {

    override public init(controller: OCKCartesianChartController, viewSynchronizer: OCKCartesianChartViewSynchronizer) {
        super.init(controller: controller, viewSynchronizer: viewSynchronizer)
    }

    override public init(viewSynchronizer: OCKCartesianChartViewSynchronizer, weekOfDate: Date,
                         configurations: [OCKDataSeriesConfiguration], storeManager: OCKSynchronizedStoreManager) {
        super.init(viewSynchronizer: viewSynchronizer, weekOfDate: weekOfDate, configurations: configurations, storeManager: storeManager)
    }

    /// Initialize a view controller that displays a chart. Fetches and stays synchronized with insights.
    /// - Parameter weekOfDate: A date in the week of the insights range to fetch.
    /// - Parameter configurations: Configurations used to fetch the insights ad display the data.
    /// - Parameter storeManager: Wraps the store that contains the insight data to fetch.
    public init(plotType: OCKCartesianGraphView.PlotType, selectedDate: Date,
                configurations: [OCKDataSeriesConfiguration], storeManager: OCKSynchronizedStoreManager) {
        let viewSynchronizer = OCKCartesianChartViewSynchronizer(plotType: plotType, selectedDate: selectedDate)
        super.init(viewSynchronizer: viewSynchronizer, weekOfDate: selectedDate, configurations: configurations, storeManager: storeManager)
    }
}

#endif
