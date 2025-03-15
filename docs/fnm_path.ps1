# 自動取得 fnm 當前使用的 node 版本真實路徑 (Chocolatey 安裝的 fnm)
$fnm_versions = "$env:APPDATA\fnm\node-versions"
$node_version = fnm current
$nodeRealPath = Join-Path $fnm_versions "$node_version\installation"

# 確認路徑存在（可手動確認）
if (Test-Path $nodeRealPath) {
    # 建立 Symbolic Link
    Remove-Item 'C:\bin\nodejs' -Force -Recurse -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path 'C:\bin\nodejs' -Target $nodeRealPath
    Write-Host "成功建立符號連結：C:\bin\nodejs -> $nodeRealPath"
} else {
    Write-Error "未找到路徑 $nodeRealPath，請確認該版本已經正確安裝。"
}
