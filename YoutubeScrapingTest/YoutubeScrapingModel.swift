//
//  YoutubeScrapingModel.swift
//  YoutubeScrapingTest
//
//  Created by Yong Jun Cha on 2021/11/30.
//

import Foundation
import SwiftSoup

class YoutubeScrapingModel {
    fileprivate let ETC = "기타"
    fileprivate let SEARCH = "검색"
    fileprivate let WATCH = "시청"
    fileprivate let VISIT = "방문"
    fileprivate let REFER = "조회"
    
    fileprivate let GOOGLE = "Google"
    fileprivate let YOUTUBE = "YouTube"
    fileprivate let YOUTUBE_MUSIC = "YouTube Music"
    
    //YouTube
    func insertYoutubeKeywordData(url : URL){
//        var keywords : [Keyword] = []
//        var index = getLastIndex() + 1
//        print("Start Index :: \(index)")
        
//        let lastDate = getLastDate(keywordType: keywordEngineType)
//        print("GET LAST DATE :: \(lastDate)")
        
        //Scraping code be delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [self] in
            do {
                print("Youtube Keyword Scraping Start")
                let html = try String(contentsOf: url, encoding: .utf8)
                
                // Get all html
                guard let doc: Document = try? SwiftSoup.parseBodyFragment(html) else {
                    print("Fail Scrap HTML DOC")
                    // Exception Handling
//                    scrapingFailAction()
                    return
                }
//                k2bP7e YYajNd
                // Select List of Searched Keywords
                let searchKeywords : Elements? = try doc.select("c-wiz[class*='xDtZAf']")
                
                if searchKeywords != nil && searchKeywords?.count != 0 {
                    
                    for searchKeyword : Element in searchKeywords!.array() {
                        // Date
                        let searchDate : String = try searchKeyword.attr("data-date")
                        
                        // Time
                        let searchTime : String = try searchKeyword.select("div[class='H3Q9vf XTnvW']").first()?.text().components(separatedBy: "•")[0].replacingOccurrences(of: " ", with: "") ?? ""
                        
                        // Date + Time Formatting
//                        let formattedDate : Date = dateFormattingForGoogle(timeString: searchTime, formattedDate: searchDate)
                        
                        // Compare With Realm Data (lastDate)
//                        if formattedDate > lastDate {
                            
                            // Keyword Buffuer
//                            let keyword = Keyword()
                            
                            // DateTime
//                            keyword.dateTime = formattedDate
                        print("DATE_TIME :: \(searchDate)")
                        print("SEARCH_TIME :: \(searchTime)")
                            
                            // id
//                            keyword.id = index
                            
                            // KeywordType
//                            keyword.keywordType = keywordEngineType
                            
                            // MainType
                            let mainType = try searchKeyword.select("span[class='hJ7x8b']").first()?.text() ?? YOUTUBE
//                            keyword.mainType = getYoutubeMainType(mainType: mainType)
                            print("MAIN_TYPE :: \(mainType)")
                            
                            // Get Row
                            let searchHtmlRow =  try searchKeyword.select("div[class='QTGV3c']").first()?.text() ?? ETC
                            
                            //SubType
                            
                            let subType = getSubType(searchHtmlRow: searchHtmlRow)
                            print("SUBTYPE :: \(subType)")
                            
                            
                            // KeyWord Name
                            let name : Element? = try searchKeyword.select("a[jsname='eLJrl']").first() ?? nil
                            print("KEYWORD :: \(String(try name?.text()  ?? "" ))")
                            
                            // Image
                            let image : String = try searchKeyword.select("img[class='M1gnGc']").attr("src")
                            print("IMAGE :: \(image)")
                            
                            // Append keyword Data
//                            keywords.append(contentsOf: [keyword])
                            
//                            index += 1
                            
                            print("-----------------------------------------------------------------------------------------------------")
//                        }
                    }
                    // Call Insert Method
//                    print("SCRAPED KEYWORD COUNT : \(keywords.count)")
//                    insertFormattedKeyword(keywordEngineType: keywordEngineType, keywords: keywords)
                } else {
                    print("KEYWORD EMPTY :: Exception Handling")
                    // Exception Handling
//                    scrapingFailAction()
                }
            } catch Exception.Error(let type, let message) {
                print("Error Type : \(type) Error Message : \(message)")
            } catch {
                print("error")
            }
        }
    }
    
    
    private func getSubType(searchHtmlRow : String) -> String {
        if searchHtmlRow.contains(ETC) {
            return "기타"
        } else if searchHtmlRow.contains(SEARCH) {
            return "검색"
        } else if searchHtmlRow.contains(WATCH) {
            return "시청"
        } else if searchHtmlRow.contains(VISIT) {
            return "방문"
        } else if searchHtmlRow.contains(REFER){
            return "조회"
        } else {
            return "기타"
        }
    }
    
    
    
}
