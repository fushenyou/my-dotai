# Figma Plugin MCP 配置脚本 (Windows PowerShell)
# 自动配置 Figma MCP 服务器

param(
    [Parameter(Mandatory=$false)]
    [string]$FigmaApiKey
)

Write-Host "🎨 配置 Figma MCP 服务器..." -ForegroundColor Green

# 检查是否提供了 Figma API Key
if ([string]::IsNullOrEmpty($FigmaApiKey)) {
    Write-Host "请提供您的 Figma API Key" -ForegroundColor Yellow
    Write-Host "获取方式：访问 https://www.figma.com/developers/api#access-tokens"
    $FigmaApiKey = Read-Host "请输入 Figma API Key (figd_xxxx)"
}

# 验证 API Key 格式（检查长度，而不是强制前缀）
# Figma Personal Access Token 通常以 figd_ 开头，但我们也接受其他格式
if ($FigmaApiKey.Length -lt 20) {
    Write-Host "错误：Figma API Key 长度不足，请检查是否正确" -ForegroundColor Red
    exit 1
}

Write-Host "✓ API Key 验证通过" -ForegroundColor Green
if ($FigmaApiKey.StartsWith("figd_")) {
    Write-Host "  (标准 Personal Access Token 格式)" -ForegroundColor Green
} else {
    Write-Host "  (注意：此 Token 不是标准的 figd_ 格式，如遇到问题请检查)" -ForegroundColor Yellow
}

# Claude Code 配置目录
$claudeDir = "$env:USERPROFILE\.claude"
$settingsFile = "$claudeDir\settings.json"

# 检查 Claude Code 配置目录
if (-not (Test-Path $claudeDir)) {
    Write-Host "错误：未找到 Claude Code 配置目录 ($claudeDir)" -ForegroundColor Red
    Write-Host "请确保已安装 Claude Code"
    exit 1
}

Write-Host "✓ 找到 Claude Code 配置目录" -ForegroundColor Green

# 读取或创建 settings.json
if (Test-Path $settingsFile) {
    $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
} else {
    Write-Host "创建 settings.json..."
    $settings = @{ env = @{} } | ConvertTo-Json
    Set-Content $settingsFile -Value $settings
    $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
}

# 添加 FIGMA_ACCESS_TOKEN 到环境变量
if (-not $settings.env) {
    $settings | Add-Member -Type NoteProperty -Name "env" -Value @{}
}

$settings.env | Add-Member -Type NoteProperty -Name "FIGMA_ACCESS_TOKEN" -Value $FigmaApiKey -Force

# 保存 settings.json
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile
Write-Host "✓ 已添加 FIGMA_ACCESS_TOKEN 到 settings.json" -ForegroundColor Green

# 启用插件
if (-not $settings.enabledPlugins) {
    $settings | Add-Member -Type NoteProperty -Name "enabledPlugins" -Value @{}
}

$settings.enabledPlugins | Add-Member -Type NoteProperty -Name "figma@my-dotai" -Value $true -Force

# 保存 settings.json
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile
Write-Host "✓ 已启用 Figma 插件" -ForegroundColor Green

Write-Host ""
Write-Host "✨ Figma MCP 配置完成！" -ForegroundColor Green
Write-Host ""
Write-Host "📝 配置摘要："
Write-Host "  - Figma API Key: $($FigmaApiKey.Substring(0, [Math]::Min(10, $FigmaApiKey.Length)))..."
Write-Host "  - 配置文件: $settingsFile"
Write-Host ""
Write-Host "🚀 下一步："
Write-Host "  1. 重启 Claude Code"
Write-Host "  2. 使用 /figma:design-to-code 命令"
Write-Host ""
Write-Host "💡 提示："
Write-Host "  - 确保设计稿已公开或有访问权限"
Write-Host "  - 首次使用可能需要安装 figma-developer-mcp"
Write-Host ""
