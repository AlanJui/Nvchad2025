# PowerShell 更新指引

0. 關閉以下所有與 Terminal 有關之 App：
   - VSCode
   - Cursor IDE
   - Windows Terminal
   - WezTerm

1. 用系統管理員權限執行 CMD。

2. 執行更新指令：

   ```powershell
   # 使用 winget 執行更新指令
   winget.exe upgrade --id Microsoft.PowerShell --source winget

   # 檢查更新結果
   pwsh.exe -NoLogo -Command "$PSVersionTable.PSVersion"
   ```

3. 順利執行結束後，關閉 CMD。

4. 重啟 Windows Terminal, WezTerm 。

【註】：

1. 已安裝之 winget 為：Microsoft Store / MSIX 版。

2. 執行時，使用 winget.exe ，勿以簡寫 winget 執行。

3. 確認 winget.exe 能否正常執行，使用指令： winget.exe --info
