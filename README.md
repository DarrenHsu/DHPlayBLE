# DHPlayBLE

## iPhone Scrren Shot
![](https://github.com/DarrenHsu/DHPlayBLE/blob/master/Screen%20Shot/thumb_IMG_4515_1024.jpg)

## iPad Scrren Shot
![](https://github.com/DarrenHsu/DHPlayBLE/blob/master/Screen%20Shot/thumb_IMG_0111_1024.jpg)

## 描述
這是一個利用 CoreBluetooth 模擬多台裝置透過 BLE 機制做到收發訊息來達到聊天室的功能，在此範例中使用相同的 Service UUID 和 Characteristic UUID 來執行，當每一台裝置開起 Bluetooth 後將會進入 Central 模式，掃描預設的 Service UUID 的裝置所發出的訊號，當掃描到之後將停止掃描，並建立 GATT 進行註冊，接著在接收預設的 Characteristic UUID，所技供的訊息。
而當使用在輸入框中輸入完訊息後，按下送出後裝置將進入 Peripheral 模式，不斷的發出訊息等待 Central 裝置註冊，
之後 Central 裝置將可以收到 Peripheral 裝置所發出的訊息，直到結尾字串出現。
  




