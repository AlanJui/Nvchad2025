# a100 程式執行流程

1. 開始
   - 開始程式

2. 初始化
   - 讀取環境變數
   - 設定日誌

3. 獲取活頁簿
   - 嘗試獲取當前活躍的 Excel 活頁簿
   - 如果失敗，記錄錯誤並終止程式

4. 檢查輸入
   - 從 V3 儲存格獲取待注音漢字
   - 如果 V3 為空，記錄警告並終止程式

5. 清除及重設格式
   - 清除儲存格內容
   - 重設儲存格格式

6. 填入漢字
   - 從 V3 逐字填入對應儲存格
   - 設定字元格式（顏色等）

7. 查找標音
   - 根據選定的語音類型查找標音
   - 如果查找失敗，記錄錯誤並終止程式

8. 儲存檔案
   - 儲存 Excel 檔案
   - 記錄儲存路徑

9. 結束
   - 結束程式

## 流程圖

使用 PlantUML Script 繪製【流程圖】。

```plantuml
@startuml
start
:初始化;
:載入環境變數;
:設置日誌;
:嘗試獲取活躍的 Excel 活頁簿;
if (找到活頁簿?) then (是)
    :檢查 V3 的輸入;
    if (V3 為空?) then (是)
        :記錄警告並終止;
        stop
    else (否)
        :清除儲存格內容;
        :重設儲存格格式;
        :從 V3 填入字元;
        :設置字元格式;
        :根據選定的類型查找標音;
        if (查找成功?) then (是)
            :儲存 Excel 檔案;
            :記錄儲存路徑;
        else (否)
            :記錄錯誤並終止;
            stop
        endif
    endif
else (否)
    :記錄錯誤並終止;
    stop
endif
:結束;
stop
@enduml
```

## 英/漢對照

```plantuml
@startuml
start
:Initialize;
:Load environment variables;
:Set up logging;
:Try to get active Excel workbook;
if (Workbook found?) then (yes)
    :Check input from V3;
    if (Is V3 empty?) then (yes)
        :Log warning and terminate;
        stop
    else (no)
        :Clear cell contents;
        :Reset cell formats;
        :Fill in characters from V3;
        :Set character formatting;
        :Look up phonetics based on selected type;
        if (Lookup successful?) then (yes)
            :Save Excel file;
            :Log save path;
        else (no)
            :Log error and terminate;
            stop
        endif
    endif
else (no)
    :Log error and terminate;
    stop
endif
:End;
stop
@enduml
```
