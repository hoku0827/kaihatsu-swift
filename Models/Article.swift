//
//  User.swift
//
//  Created by Kazuya Tateishi on 2015/03/25.
//  Copyright (c) 2015年 kzy52. All rights reserved.
//

import UIKit

struct Article {
    var title: String
    var url: String
    var image: String
    var publisher: String
}

class ArticleDataManager: NSObject {
    var articles: [Article]
    
    class var sharedInstance : ArticleDataManager {
        struct Static {
            static let instance : ArticleDataManager = ArticleDataManager()
        }
        return Static.instance
    }
    
    override init() {
        self.articles = []
    }
    
    // ユーザーの総数を返す。
    var size : Int {
        return self.articles.count
    }
    
    // 配列のように[n]で要素を取得できるようにする。
    subscript(index: Int) -> Article {
        return self.articles[index]
    }
    
    func set(article: Article) {
        self.articles.append(article)
    }
}