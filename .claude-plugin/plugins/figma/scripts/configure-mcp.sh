#!/bin/bash

# Figma MCP 自动配置脚本
# 在每次会话开始时检查配置

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查是否已配置 FIGMA_ACCESS_TOKEN
if [ -z "$FIGMA_ACCESS_TOKEN" ]; then
    # 检查是否已经在 settings.json 中配置
    if command -v jq &> /dev/null; then
        TOKEN=$(jq -r '.env.FIGMA_ACCESS_TOKEN // empty' ~/.claude/settings.json 2>/dev/null)

        if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
            echo -e "${YELLOW}⚠️  Figma 插件未配置 API Key${NC}"
            echo ""
            echo "请运行以下命令配置："
            echo "  cd ${CLAUDE_PLUGIN_ROOT}"
            echo "  bash install.sh figd_your_token_here"
            echo ""
            echo "或者访问 https://www.figma.com/developers/api#access-tokens 获取 token"
        fi
    fi
fi
