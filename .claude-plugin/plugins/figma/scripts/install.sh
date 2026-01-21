#!/bin/bash

# Figma 插件安装脚本

set -e

echo "🎨 正在安装 Figma 设计稿转代码插件..."

# 检查 Node.js 是否安装
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 未找到 Node.js，请先安装 Node.js"
    exit 1
fi

# 检查 npm 是否安装
if ! command -v npm &> /dev/null; then
    echo "❌ 错误: 未找到 npm，请先安装 npm"
    exit 1
fi

echo "✅ Node.js 和 npm 已安装"

# 安装 js-yaml（如果需要）
if ! command -v js-yaml &> /dev/null; then
    echo "📦 正在安装 js-yaml..."
    npm install -g js-yaml
fi

echo "✅ Figma 插件安装完成！"
echo ""
echo "使用方法:"
echo "  /figma <Figma 文件 URL>"
echo ""
echo "示例:"
echo "  /figma https://www.figma.com/file/xxxxx/Design-System"
