#!/bin/bash

# Figma Plugin MCP 配置脚本
# 自动配置 Figma MCP 服务器

set -e

echo "🎨 配置 Figma MCP 服务器..."

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查是否提供了 Figma API Key
if [ -z "$1" ]; then
    echo -e "${YELLOW}请提供您的 Figma API Key${NC}"
    echo "获取方式：访问 https://www.figma.com/developers/api#access-tokens"
    read -p "请输入 Figma API Key (figd_xxxx): " FIGMA_API_KEY
else
    FIGMA_API_KEY="$1"
fi

# 验证 API Key 格式
if [[ ! $FIGMA_API_KEY =~ ^figd_ ]]; then
    echo -e "${RED}错误：Figma API Key 格式不正确，应该以 'figd_' 开头${NC}"
    exit 1
fi

echo -e "${GREEN}✓ API Key 验证通过${NC}"

# Claude Code 配置目录
CLAUDE_DIR="$HOME/.claude"
PLUGINS_DIR="$CLAUDE_DIR/plugins"

# 检查 Claude Code 配置目录
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}错误：未找到 Claude Code 配置目录 ($CLAUDE_DIR)${NC}"
    echo "请确保已安装 Claude Code"
    exit 1
fi

echo -e "${GREEN}✓ 找到 Claude Code 配置目录${NC}"

# 创建或更新 settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "创建 settings.json..."
    echo '{"env": {}}' > "$SETTINGS_FILE"
fi

# 使用 jq 更新 settings.json，添加 FIGMA_ACCESS_TOKEN 到环境变量
if command -v jq &> /dev/null; then
    echo "更新 settings.json..."
    tmp=$(mktemp)
    jq --arg key "$FIGMA_API_KEY" '.env.FIGMA_ACCESS_TOKEN = $key' "$SETTINGS_FILE" > "$tmp"
    mv "$tmp" "$SETTINGS_FILE"
    echo -e "${GREEN}✓ 已添加 FIGMA_ACCESS_TOKEN 到 settings.json${NC}"
else
    echo -e "${YELLOW}警告：未安装 jq，跳过自动更新 settings.json${NC}"
    echo "请手动添加以下内容到 ~/.claude/settings.json："
    echo "  \"env\": {"
    echo "    \"FIGMA_ACCESS_TOKEN\": \"$FIGMA_API_KEY\""
    echo "  }"
fi

# 启用插件
if command -v jq &> /dev/null; then
    echo "启用 Figma 插件..."
    tmp=$(mktemp)
    jq '.enabledPlugins["figma@my-dotai"] = true' "$SETTINGS_FILE" > "$tmp"
    mv "$tmp" "$SETTINGS_FILE"
    echo -e "${GREEN}✓ 已启用 Figma 插件${NC}"
fi

echo ""
echo -e "${GREEN}✨ Figma MCP 配置完成！${NC}"
echo ""
echo "📝 配置摘要："
echo "  - Figma API Key: ${FIGMA_API_KEY:0:10}..."
echo "  - 配置文件: ~/.claude/settings.json"
echo ""
echo "🚀 下一步："
echo "  1. 重启 Claude Code"
echo "  2. 使用 /figma:design-to-code 命令"
echo ""
echo "💡 提示："
echo "  - 确保设计稿已公开或有访问权限"
echo "  - 首次使用可能需要安装 figma-developer-mcp"
echo ""
