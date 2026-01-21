# Figma 设计稿转代码插件

自动从 Figma 设计稿生成前端代码，智能识别项目框架和编码规范。

## 功能特性

- ✨ 自动检测项目技术栈（React、Vue、Svelte、Angular 等）
- 🎨 高度还原 Figma 设计稿
- 📦 支持多种 UI 库（shadcn/ui、Material-UI、Ant Design 等）
- 🎯 支持多种样式方案（Tailwind CSS、CSS Modules、Styled Components 等）
- 🔧 自动遵循项目代码规范
- 📝 支持 TypeScript
- 🚀 一键生成组件代码

## 安装

### 通过 Claude Code Marketplace 安装（推荐）

```bash
# 在 Claude Code 中执行
/extension install figma
```

### 手动安装

```bash
# 克隆插件仓库
git clone https://github.com/your-repo/my-dotai.git

# 复制到插件目录
cp -r my-dotai/.claude-plugin/plugins/figma ~/.claude/plugins/
```

## 使用方法

### 基础用法

```
/figma https://www.figma.com/design/IqF4MMDX460Y5j1GAEoHlY/专病（管理台）?node-id=118-34&t=5HL5eA8NA5dceDDg-4
```

### 指定目标路径

```
/figma https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2003-4346&t=LWOhD6SdldAyv4zY-4 --path=src/components/Button
```

### 指定框架

```
/figma https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --framework=react --ui=tailwind
```

## 技术栈

- **MCP Server**: figma-developer-mcp
- **支持框架**: React、Vue、Svelte、Angular、Solid、Qwik
- **支持样式**: Tailwind CSS、CSS Modules、Styled Components、Emotion
- **支持 UI 库**: shadcn/ui、Material-UI、Ant Design、Chakra UI、Radix UI

## 配置

插件会自动配置 MCP 服务器：

```json
{
  "mcpServers": {
    "Framelink Figma MCP": {
      "command": "npx",
      "args": [
        "-y",
        "figma-developer-mcp",
        "--figma-api-key=figd_xxxx",
        "--stdio"
      ]
    }
  }
}
```

## 工作流程

1. **分析项目**: 自动检测项目的技术栈和编码规范
2. **获取设计**: 通过 MCP 获取 Figma 设计数据
3. **生成代码**: 根据项目规范生成组件代码
4. **创建文件**: 将代码写入适当位置
5. **验证结果**: 确认文件创建成功

## 示例

### React + Tailwind CSS

**输入**:
```
/figma https://www.figma.com/file/xxxxx/Login-Page
```

**输出**:
```jsx
// src/components/LoginPage.tsx
import React from 'react';

export default function LoginPage() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-white">
      <div className="w-full max-w-md rounded-lg bg-white p-6 shadow-lg">
        <h1 className="text-2xl font-bold text-gray-900">
          欢迎登录
        </h1>
        <form className="mt-4 space-y-4">
          {/* 表单内容 */}
        </form>
      </div>
    </div>
  );
}
```

### Vue 3 + CSS Modules

**输入**:
```
/figma https://www.figma.com/file/xxxxx/Dashboard
```

**输出**:
```vue
<!-- src/components/Dashboard.vue -->
<template>
  <div :class="$styles.container">
    <div :class="$styles.card">
      <h1 :class="$styles.title">仪表盘</h1>
    </div>
  </div>
</template>

<script setup lang="ts">
// 组件逻辑
</script>

<style module>
.container {
  display: flex;
  min-height: 100vh;
  align-items: center;
  justify-content: center;
}
</style>
```

## 故障排除

### MCP 连接失败

- 检查 API Key 是否有效
- 确认 figma-developer-mcp 已正确安装
- 查看错误日志获取详细信息

### 框架检测错误

- 手动指定框架：`/figma <URL> --framework=react`
- 检查 package.json 中的依赖

### 生成的代码不符合规范

- 提供现有组件作为参考
- 明确指定编码规范要求

## 开发

### 项目结构

```
.claude-plugin/plugins/figma/
├── .claude-plugin/
│   ├── plugin.json
│   └── .mcp.json
├── commands/
│   └── to-code.md
├── scripts/
│   ├── detect-framework.js
│   ├── install.sh
│   └── uninstall.sh
├── SKILL.md
└── README.md
```

### 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 作者

fusy

## 相关资源

- [Claude Code 文档](https://claude.com/claude-code)
- [figma-developer-mcp](https://github.com/framelink-ai/figma-developer-mcp)
- [Figma API 文档](https://www.figma.com/developers/api)
