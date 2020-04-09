# FlickrDemo

*下載專案後需要更換[flickr token](https://www.flickr.com/services/api/explore/flickr.photos.search)*

## 設計方向
* 搜尋頁面提供輸入關鍵字跟每頁呈現數量
* 搜尋結果以照片牆呈現
* 照片牆實現infinite scroll
* 照片牆可以加入我的最愛，並儲存至local，並在我的最愛分頁可以看到

## 使用技術
### UI
* 在表單輸入考量UX，輸入完關鍵字，自動focus下一欄位，驗證無誤才能點選搜尋按鈕
* 實現infinite scroll時，發現用reload方式會導致更新的閃爍，後來用batch update方式優化

### API
* 原先API相關程式都在controller view當中，變得非常雜亂，最後採用幾個優化方式：
	1. 將部份API獨立出來撰寫成API Layer封裝
	2. 圖片延遲載入跟判別isNilOrEmpty程式以extension方式封裝。
