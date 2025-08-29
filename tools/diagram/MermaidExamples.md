# 使用 Mermaid Script 繪製圖表

## 流程圖

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

## 心智圖

```mermaid
mindmap
  root((mindmap))
    Origins
      Long history
      ::icon(fa fa-book)
      Popularisation
        British popular psychology author Tony Buzan
    Research
      On effectiveness<br/>and features
      On Automatic creation
        Uses
            Creative techniques
            Strategic planning
            Argument mapping
    Tools
      Pen and paper
      Mermaid
```
