# a101 程式執行流程

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

使用 Mermaid Script 繪製【流程圖】。

```mermaid
flowchart TD
    A[開始] --> B[初始化]
    B --> C[載入環境變數]
    C --> D[設置日誌]
    D --> E[嘗試獲取活躍的 Excel 活頁簿]
    E -->|找到活頁簿?| F[檢查 V3 的輸入]
    E -->|否| G[記錄錯誤並終止]
    F -->|V3 為空?| H[記錄警告並終止]
    F -->|否| I[清除儲存格內容]
    I --> J[重設儲存格格式]
    J --> K[從 V3 填入字元]
    K --> L[設置字元格式]
    L --> M[根據選定的類型查找標音]
    M -->|查找成功?| N[儲存 Excel 檔案]
    M -->|否| O[記錄錯誤並終止]
    N --> P[記錄儲存路徑]
    P --> Q[結束]
    G --> Q
    H --> Q
    O --> Q
```

## 英/漢對照

```mermaid
flowchart TD
    A[Start] --> B[Initialize]
    B --> C[Load environment variables]
    C --> D[Set up logging]
    D --> E[Try to get active Excel workbook]
    E -->|Workbook found?| F[Check input from V3]
    E -->|No| G[Log error and terminate]
    F -->|Is V3 empty?| H[Log warning and terminate]
    F -->|No| I[Clear cell contents]
    I --> J[Reset cell formats]
    J --> K[Fill in characters from V3]
    K --> L[Set character formatting]
    L --> M[Look up phonetics based on selected type]
    M -->|Lookup successful?| N[Save Excel file]
    M -->|No| O[Log error and terminate]
    N --> P[Log save path]
    P --> Q[End]
    G --> Q
    H --> Q
    O --> Q
`
```
