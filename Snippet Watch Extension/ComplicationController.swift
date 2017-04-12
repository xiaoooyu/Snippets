//
//  ComplicationController.swift
//  Snippet Watch Extension
//
//  Created by Yin Xiaoyu on 4/12/17.
//  Copyright © 2017 Yin Xiaoyu. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
//        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        var template: CLKComplicationTemplate
        
        switch complication.family {
        case .circularSmall:
            let t = CLKComplicationTemplateCircularSmallSimpleImage()
            let image = UIImage(named: "Circular")!
            t.imageProvider = CLKImageProvider(onePieceImage: image)
            template = t
        case .modularSmall:
            let t = CLKComplicationTemplateModularSmallSimpleImage()
            let image = UIImage(named: "Modular")!
            t.imageProvider = CLKImageProvider(onePieceImage: image)
            template = t
        case .utilitarianSmall:
            let t = CLKComplicationTemplateUtilitarianSmallSquare()
            let image = UIImage(named:"Utilitarian")!
            t.imageProvider = CLKImageProvider(onePieceImage: image)
            template = t
        default:
            handler(nil)
            return
        }
        template.tintColor = UIColor.white
        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
}
