# Figma 设计稿转代码功能 - 详细实施计划

## 项目概述

创建一个完整的 Figma 插件，能够自动调用 `figma-developer-mcp` 获取 Figma 设计数据，并根据项目的前端框架和编码规范自动生成代码。

## 技术栈

- **MCP Server**: figma-developer-mcp
- **Figma API Key**: figd_xxxx
- **插件系统**: Claude Code Plugin System
- **技能系统**: Claude Code Skills

## 目录结构

```
.claude-plugin/plugins/figma/
├── .claude-plugin/
│   ├── plugin.json          # 插件配置文件
│   └── .mcp.json            # MCP 服务器配置
├── commands/
│   └── to-code.md     # 命令文档
├── scripts/
│   ├── detect-framework.js  # 前端框架检测脚本
│   └── generate-code.js     # 代码生成脚本（可选）
├── SKILL.md                 # 技能定义文件
├── README.md                # 插件使用说明
└── ARCHITECTURE.md          # 架构文档（可选）
```

## 实施步骤

### 步骤 1: 创建插件目录结构

**目标**: 创建完整的插件目录结构

**操作**:
```bash
# 在项目根目录执行
mkdir -p .claude-plugin/plugins/figma/.claude-plugin
mkdir -p .claude-plugin/plugins/figma/commands
mkdir -p .claude-plugin/plugins/figma/scripts
```

**验证**:
```bash
ls -la .claude-plugin/plugins/figma/
# 应该看到：.claude-plugin/, commands/, scripts/
```

---

### 步骤 2: 创建 MCP 配置文件

**文件路径**: `.claude-plugin/plugins/figma/.claude-plugin/.mcp.json`

**完整内容**:
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

**说明**:
- 配置 figma-developer-mcp 服务器
- 使用提供的 API Key
- `-y` 参数自动确认 npx 安装

**验证**:
```bash
cat .claude-plugin/plugins/figma/.claude-plugin/.mcp.json
# 应该看到完整的 JSON 配置，且格式正确
```

---

### 步骤 3: 创建插件配置文件

**文件路径**: `.claude-plugin/plugins/figma/.claude-plugin/plugin.json`

**完整内容**:
```json
{
  "name": "figma",
  "displayName": "Figma 设计稿转代码",
  "version": "1.0.0",
  "description": "自动从 Figma 设计稿生成代码，支持多种前端框架",
  "author": "fusy",
  "license": "MIT",
  "skills": [
    {
      "name": "figma:design-to-code",
      "displayName": "Figma 设计稿转代码",
      "description": "根据 Figma 设计稿自动生成前端代码，智能识别项目框架和规范",
      "file": "SKILL.md",
      "alwaysApply": false
    }
  ],
  "commands": [
    {
      "name": "figma:to-code",
      "displayName": "/figma",
      "description": "从 Figma 设计稿生成代码",
      "file": "commands/to-code.md"
    }
  ],
  "mcp": ".mcp.json",
  "hooks": {
    "onInstall": "scripts/install.sh",
    "onUninstall": "scripts/uninstall.sh"
  }
}
```

**说明**:
- 定义插件元数据
- 注册技能和命令
- 关联 MCP 配置
- 配置安装/卸载钩子

**验证**:
```bash
cat .claude-plugin/plugins/figma/.claude-plugin/plugin.json | jq .
# 应该看到格式正确的 JSON，无语法错误
```

---

### 步骤 4: 创建技能定义文件

**文件路径**: `.claude-plugin/plugins/figma/SKILL.md`

**完整内容**:
```markdown
---
description: 根据 Figma 设计稿自动生成前端代码，智能识别项目框架和编码规范
---

# Figma 设计稿转代码

## 概述

该技能自动调用 figma-developer-mcp 获取 Figma 设计数据，并根据项目的：
- 前端框架（React、Vue、Svelte、Angular 等）
- UI 库（shadcn/ui、Material-UI、Ant Design 等）
- 样式方案（CSS Modules、Tailwind CSS、Styled Components 等）
- 项目结构规范

自动生成高质量、符合项目规范的代码。

## 触发条件

当用户请求以下任务时自动触发：
- "从 Figma 设计稿生成代码"
- "实现这个 Figma 设计"
- "根据设计稿创建页面"
- "将 Figma 设计转换为代码"
- 使用 `/figma` 命令

## 工作流程

### 1. 分析项目环境

首先检测项目的技术栈：

```javascript
// 检测逻辑（示例）
const detectFramework = () => {
  if (exists('package.json')) {
    const deps = readJson('package.json').dependencies || {};
    if (deps.react) return 'react';
    if (deps.vue) return 'vue';
    if (deps.svelte) return 'svelte';
    if (deps['@angular/core']) return 'angular';
  }
  return 'vanilla';
};
```

检测项包括：
- **前端框架**: React、Vue、Svelte、Angular、Solid
- **UI 库**: shadcn/ui、Material-UI、Ant Design、Chakra UI、Radix UI
- **样式方案**: Tailwind CSS、CSS Modules、Styled Components、Emotion
- **TypeScript**: 是否使用 TypeScript
- **路由系统**: React Router、Vue Router 等
- **状态管理**: Redux、Zustand、Pinia 等

### 2. 获取 Figma 设计数据

通过 MCP 工具调用 figma-developer-mcp：

```
使用 get_figma_data 或相关工具获取：
- 设计稿布局结构
- 组件层级关系
- 样式属性（颜色、字体、间距等）
- 响应式断点
- 交互状态
```

如果存在图片资源 询问后 使用 download_figma_images 工具下载图片。


### 3. 生成组件代码

根据检测到的框架和规范生成代码：

**React + Tailwind CSS 示例**:
```jsx
import React from 'react';

export default function ComponentName() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-white">
      <div className="w-full max-w-md rounded-lg bg-white p-6 shadow-lg">
        <h1 className="text-2xl font-bold text-gray-900">
          标题文本
        </h1>
        <p className="mt-2 text-gray-600">
          描述文本
        </p>
      </div>
    </div>
  );
}
```

**Vue 3 + CSS Modules 示例**:
```vue
<template>
  <div class="container">
    <div class="card">
      <h1 class="title">标题文本</h1>
      <p class="description">描述文本</p>
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
  background: white;
}

.card {
  width: 100%;
  max-width: 28rem;
  padding: 1.5rem;
  border-radius: 0.5rem;
  background: white;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
}

.description {
  margin-top: 0.5rem;
  color: #4b5563;
}
</style>
```

### 4. 整合到项目结构

根据项目结构规范创建文件：
- **Next.js**: `app/` 或 `pages/` 目录
- **React**: `src/components/` 目录
- **Vue 3**: `src/components/` 目录
- **Nuxt**: `components/` 目录

### 5. 代码质量保证

确保生成的代码：
- 符合项目的 ESLint/Prettier 配置
- 使用项目现有的组件和工具函数
- 遵循命名约定
- 包含必要的类型定义（TypeScript 项目）
- 添加合理的注释

## 工具使用

在执行过程中，会使用以下 MCP 工具：

1. **获取设计数据**:
   - 调用 `figma-developer-mcp` 工具
   - 传递 Figma 文件 URL 或节点 ID

2. **读取项目配置**:
   - 使用 `Read` 工具读取 `package.json`、`tsconfig.json` 等
   - 使用 `Glob` 查找现有组件作为参考

3. **创建文件**:
   - 使用 `Write` 工具创建新组件文件
   - 使用 `Edit` 工具修改现有文件

## 最佳实践

1. **保持代码简洁**: 避免过度抽象，优先直接实现
2. **复用现有组件**: 检测项目中已有的 UI 组件并复用
3. **响应式设计**: 根据 Figma 的自适应布局生成响应式代码
4. **可访问性**: 添加必要的 ARIA 属性和语义化标签
5. **性能优化**: 使用懒加载、代码分割等优化策略

## 输出示例

**输入**:
- Figma 设计稿 URL
- 目标文件路径（可选）

**输出**:
- 完整的组件代码文件
- 相关的类型定义文件（如需要）
- 样式文件（如需要）
- 集成说明

## 故障排除

### 问题 1: MCP 连接失败
- 检查 API Key 是否有效
- 确认 figma-developer-mcp 已正确安装
- 查看错误日志获取详细信息

### 问题 2: 框架检测错误
- 手动指定框架：`使用 React + Tailwind CSS 实现`
- 检查 package.json 中的依赖

### 问题 3: 生成的代码不符合规范
- 提供现有组件作为参考
- 明确指定编码规范要求

## 扩展功能

未来可以添加的功能：
- 支持更多前端框架（Qwik、Astro 等）
- 自动生成单元测试
- 集成 Storybook
- 支持设计系统自动同步
- 版本对比和更新
```

**说明**:
- 定义技能的工作流程和最佳实践
- 提供多种框架的代码示例
- 包含故障排除指南

**验证**:
```bash
cat .claude-plugin/plugins/figma/SKILL.md
# 应该看到完整的技能文档
```

---

### 步骤 5: 创建命令文档文件

**文件路径**: `.claude-plugin/plugins/figma/commands/to-code.md`

**完整内容**:
```markdown
---
description: 从 Figma 设计稿生成代码
---

# /figma - Figma 设计稿转代码

## 用法

\`\`\`
/figma <Figma 文件 URL 或节点 ID>
\`\`\`

## 示例

### 基础用法
\`\`\`
/figma https://www.figma.com/file/xxxxx/Design-System
\`\`\`

### 指定目标路径
\`\`\`
/figma https://www.figma.com/file/xxxxx/Component --path=src/components/Button
\`\`\`

### 指定框架
\`\`\`
/figma https://www.figma.com/file/xxxxx/Page --framework=react --ui=tailwind
\`\`\`

## 工作流程

1. **解析输入**: 获取 Figma URL 和参数
2. **检测项目**: 分析项目的技术栈
3. **获取设计**: 调用 MCP 获取设计数据
4. **生成代码**: 根据规范生成组件代码
5. **创建文件**: 将代码写入适当位置
6. **验证结果**: 确认文件创建成功

## 参数说明

- `--path`: 指定生成文件的路径（可选）
- `--framework`: 强制指定框架（可选：react、vue、svelte、angular）
- `--ui`: 指定 UI 库（可选：tailwind、material-ui、ant-design）
- `--typescript`: 使用 TypeScript（默认自动检测）
- `--force`: 覆盖已存在的文件

## 注意事项

- 确保 Figma 文件有访问权限
- API Key 需要有足够的权限
- 建议在 Git 分支上使用，便于审查和修改
```

**说明**:
- 定义命令的使用方式和参数
- 提供清晰的示例

**验证**:
```bash
cat .claude-plugin/plugins/figma/commands/to-code.md
# 应该看到完整的命令文档
```

---

### 步骤 6: 创建前端框架检测脚本

**文件路径**: `.claude-plugin/plugins/figma/scripts/detect-framework.js`

**完整内容**:
```javascript
#!/usr/bin/env node

/**
 * 前端框架和项目配置检测脚本
 * 自动识别项目使用的前端框架、UI 库、样式方案等
 */

const fs = require('fs');
const path = require('path');

/**
 * 读取 JSON 文件
 */
function readJson(filePath) {
  try {
    if (fs.existsSync(filePath)) {
      const content = fs.readFileSync(filePath, 'utf-8');
      return JSON.parse(content);
    }
  } catch (error) {
    // 忽略错误
  }
  return null;
}

/**
 * 检测前端框架
 */
function detectFramework(projectRoot = process.cwd()) {
  const packageJsonPath = path.join(projectRoot, 'package.json');
  const packageJson = readJson(packageJsonPath);

  if (!packageJson) {
    return { framework: 'unknown', isTypeScript: false };
  }

  const deps = {
    ...packageJson.dependencies,
    ...packageJson.devDependencies,
  };

  // 检测框架
  let framework = 'vanilla';
  let frameworkVersion = null;

  if (deps.react) {
    framework = 'react';
    frameworkVersion = deps.react;
  } else if (deps.vue) {
    framework = 'vue';
    frameworkVersion = deps.vue;
  } else if (deps.svelte) {
    framework = 'svelte';
    frameworkVersion = deps.svelte;
  } else if (deps['@angular/core']) {
    framework = 'angular';
    frameworkVersion = deps['@angular/core'];
  } else if (deps.solid-js) {
    framework = 'solid';
    frameworkVersion = deps.solid-js;
  } else if (deps['@builder.io/qwik']) {
    framework = 'qwik';
    frameworkVersion = deps['@builder.io/qwik'];
  }

  // 检测 TypeScript
  const isTypeScript = deps.typescript !== undefined ||
    fs.existsSync(path.join(projectRoot, 'tsconfig.json'));

  // 检测元框架（Next.js、Nuxt、SvelteKit 等）
  let metaFramework = null;
  if (deps.next && deps.react) {
    metaFramework = 'nextjs';
  } else if (deps.nuxt && deps.vue) {
    metaFramework = 'nuxt';
  } else if (deps['@sveltejs/kit'] && deps.svelte) {
    metaFramework = 'sveltekit';
  } else if (deps['@astrojs/core']) {
    metaFramework = 'astro';
  } else if (deps.remix && deps.react) {
    metaFramework = 'remix';
  }

  // 检测 UI 库
  const uiLibraries = [];
  if (deps['@mui/material']) uiLibraries.push('material-ui');
  if (deps['@chakra-ui/react']) uiLibraries.push('chakra-ui');
  if (deps['@radix-ui/react']) uiLibraries.push('radix-ui');
  if (deps.antd) uiLibraries.push('ant-design');
  if (deps['@geist-ui/react']) uiLibraries.push('geist-ui');
  if (deps['@mantine/core']) uiLibraries.push('mantine');

  // 检测 shadcn/ui（特殊处理，因为它不是 npm 包）
  const componentsPath = path.join(projectRoot, 'components');
  const uiPath = path.join(projectRoot, 'components/ui');
  if (fs.existsSync(uiPath)) {
    const uiFiles = fs.readdirSync(uiPath);
    if (uiFiles.length > 0) {
      uiLibraries.push('shadcn-ui');
    }
  }

  // 检测样式方案
  let styling = 'css';
  if (deps.tailwindcss) {
    styling = 'tailwind';
  } else if (deps['styled-components']) {
    styling = 'styled-components';
  } else if (deps.emotion) {
    styling = 'emotion';
  } else if (deps['@emotion/styled']) {
    styling = 'emotion';
  }

  // 检测路由
  let routing = null;
  if (deps['react-router']) {
    routing = 'react-router';
  } else if (deps['react-router-dom']) {
    routing = 'react-router-dom';
  } else if (deps['vue-router']) {
    routing = 'vue-router';
  } else if (deps['@angular/router']) {
    routing = 'angular-router';
  }

  // 检测状态管理
  const stateManagement = [];
  if (deps.redux || deps['@reduxjs/toolkit']) {
    stateManagement.push('redux');
  }
  if (deps.zustand) {
    stateManagement.push('zustand');
  }
  if (deps.jotai) {
    stateManagement.push('jotai');
  }
  if (deps.recoil) {
    stateManagement.push('recoil');
  }
  if (deps.pinia) {
    stateManagement.push('pinia');
  }
  if (deps.vuex) {
    stateManagement.push('vuex');
  }

  // 检测项目结构
  let projectStructure = 'default';
  const srcPath = path.join(projectRoot, 'src');
  const appPath = path.join(projectRoot, 'app');
  const pagesPath = path.join(projectRoot, 'pages');

  if (fs.existsSync(appPath) && metaFramework === 'nextjs') {
    projectStructure = 'nextjs-app';
  } else if (fs.existsSync(pagesPath) && metaFramework === 'nextjs') {
    projectStructure = 'nextjs-pages';
  } else if (fs.existsSync(srcPath)) {
    projectStructure = 'src-based';
  }

  return {
    framework,
    frameworkVersion,
    isTypeScript,
    metaFramework,
    uiLibraries,
    styling,
    routing,
    stateManagement,
    projectStructure,
    dependencies: Object.keys(deps),
  };
}

/**
 * 检测代码风格配置
 */
function detectCodeStyle(projectRoot = process.cwd()) {
  const result = {
    eslint: false,
    prettier: false,
    editorconfig: false,
  };

  // 检测 ESLint
  const eslintConfigs = [
    '.eslintrc.js',
    '.eslintrc.json',
    '.eslintrc.yml',
    '.eslintrc.yaml',
    'eslint.config.js',
  ];
  result.eslint = eslintConfigs.some((file) =>
    fs.existsSync(path.join(projectRoot, file))
  );

  // 检测 Prettier
  const prettierConfigs = [
    '.prettierrc',
    '.prettierrc.js',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    'prettier.config.js',
  ];
  result.prettier = prettierConfigs.some((file) =>
    fs.existsSync(path.join(projectRoot, file))
  );

  // 检测 EditorConfig
  result.editorconfig = fs.existsSync(
    path.join(projectRoot, '.editorconfig')
  );

  return result;
}

/**
 * 主函数
 */
function main() {
  const args = process.argv.slice(2);
  const projectRoot = args[0] || process.cwd();

  const frameworkInfo = detectFramework(projectRoot);
  const codeStyle = detectCodeStyle(projectRoot);

  const result = {
    ...frameworkInfo,
    codeStyle,
  };

  // 输出 JSON 格式
  console.log(JSON.stringify(result, null, 2));
}

// 如果直接运行此脚本
if (require.main === module) {
  main();
}

module.exports = { detectFramework, detectCodeStyle };
```

**说明**:
- 自动检测项目的前端框架、UI 库、样式方案等
- 输出 JSON 格式的检测结果
- 可以作为独立脚本使用，也可以作为模块导入

**验证**:
```bash
cd .claude-plugin/plugins/figma/scripts
chmod +x detect-framework.js
node detect-framework.js /Users/fusy/workspace/diy/my-dotai
# 应该看到 JSON 格式的检测结果
```

---

### 步骤 7: 创建安装脚本

**文件路径**: `.claude-plugin/plugins/figma/scripts/install.sh`

**完整内容**:
```bash
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
```

**验证**:
```bash
chmod +x .claude-plugin/plugins/figma/scripts/install.sh
```

---

### 步骤 8: 创建卸载脚本

**文件路径**: `.claude-plugin/plugins/figma/scripts/uninstall.sh`

**完整内容**:
```bash
#!/bin/bash

# Figma 插件卸载脚本

set -e

echo "🗑️  正在卸载 Figma 设计稿转代码插件..."

# 这里可以添加清理逻辑
# 例如：删除缓存、配置文件等

echo "✅ Figma 插件卸载完成！"
```

**验证**:
```bash
chmod +x .claude-plugin/plugins/figma/scripts/uninstall.sh
```

---

### 步骤 9: 创建 README 文档

**文件路径**: `.claude-plugin/plugins/figma/README.md`

**完整内容**:
```markdown
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


### 手动安装

\`\`\`bash
# 克隆插件仓库
git clone https://github.com/your-repo/my-dotai.git

# 复制到插件目录
cp -r my-dotai/.claude-plugin/plugins/figma ~/.claude/plugins/
\`\`\`

## 使用方法

### 基础用法

\`\`\`
/figma:to-code https://www.figma.com/design/IqF4MMDX460Y5j1GAEoHlY/%E4%B8%93%E7%97%85%EF%BC%88%E7%AE%A1%E7%90%86%E5%8F%B0%EF%BC%89?node-id=118-34&t=5HL5eA8NA5dceDDg-4
\`\`\`

### 指定目标路径

\`\`\`
/figma https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2003-4346&t=LWOhD6SdldAyv4zY-4 --path=src/components/Button
\`\`\`

### 指定框架

\`\`\`
/figma https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --framework=react --ui=tailwind
\`\`\`

## 技术栈

- **MCP Server**: figma-developer-mcp
- **支持框架**: React、Vue、Svelte、Angular、Solid、Qwik
- **支持样式**: Tailwind CSS、CSS Modules、Styled Components、Emotion
- **支持 UI 库**: shadcn/ui、Material-UI、Ant Design、Chakra UI、Radix UI

## 配置

插件会自动配置 MCP 服务器：

\`\`\`json
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
\`\`\`

## 工作流程

1. **分析项目**: 自动检测项目的技术栈和编码规范
2. **获取设计**: 通过 MCP 获取 Figma 设计数据
3. **生成代码**: 根据项目规范生成组件代码
4. **创建文件**: 将代码写入适当位置
5. **验证结果**: 确认文件创建成功

## 示例

### React + Tailwind CSS

**输入**:
\`\`\`
/figma https://www.figma.com/file/xxxxx/Login-Page
\`\`\`

**输出**:
\`\`\`jsx
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
\`\`\`

### Vue 3 + CSS Modules

**输入**:
\`\`\`
/figma https://www.figma.com/file/xxxxx/Dashboard
\`\`\`

**输出**:
\`\`\`vue
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
\`\`\`

## 故障排除

### MCP 连接失败

- 检查 API Key 是否有效
- 确认 figma-developer-mcp 已正确安装
- 查看错误日志获取详细信息

### 框架检测错误

- 手动指定框架：\`/figma <URL> --framework=react\`
- 检查 package.json 中的依赖

### 生成的代码不符合规范

- 提供现有组件作为参考
- 明确指定编码规范要求

## 开发

### 项目结构

\`\`\`
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
\`\`\`

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
```

**验证**:
```bash
cat .claude-plugin/plugins/figma/README.md
# 应该看到完整的 README 文档
```

---

### 步骤 10: 注册插件到市场配置

**文件路径**: `.claude-plugin/marketplace.json`

**操作**: 在现有配置中添加 Figma 插件

**完整内容示例**（需要在现有配置基础上添加）:
```json
{
  "plugins": [
    {
      "name": "git",
      "displayName": "Git 插件",
      "repository": "https://github.com/...",
      "version": "1.0.0"
    },
    {
      "name": "figma",
      "displayName": "Figma 设计稿转代码",
      "repository": "https://github.com/fusy/my-dotai",
      "version": "1.0.0",
      "description": "自动从 Figma 设计稿生成前端代码",
      "author": "fusy",
      "tags": ["figma", "design", "code-generation", "ui"],
      "icon": "🎨"
    }
  ]
}
```

**验证**:
```bash
cat .claude-plugin/marketplace.json | jq .plugins[]
# 应该看到新添加的 figma 插件配置
```

---

### 步骤 11: 创建插件注册表文件

**文件路径**: `registry/figma.json`

**完整内容**:
```json
{
  "name": "figma",
  "version": "1.0.0",
  "displayName": "Figma 设计稿转代码",
  "description": "自动从 Figma 设计稿生成前端代码，智能识别项目框架和编码规范",
  "author": "fusy",
  "license": "MIT",
  "homepage": "https://github.com/fusy/my-dotai",
  "repository": {
    "type": "git",
    "url": "https://github.com/fusy/my-dotai.git"
  },
  "keywords": [
    "figma",
    "design",
    "code-generation",
    "ui",
    "react",
    "vue",
    "svelte",
    "angular"
  ],
  "skills": [
    {
      "id": "figma:design-to-code",
      "name": "Figma 设计稿转代码",
      "description": "根据 Figma 设计稿自动生成前端代码"
    }
  ],
  "commands": [
    {
      "id": "figma:to-code",
      "name": "/figma",
      "description": "从 Figma 设计稿生成代码"
    }
  ],
  "mcp": {
    "server": "Framelink Figma MCP",
    "package": "figma-developer-mcp"
  },
  "dependencies": {
    "node": ">=14.0.0",
    "npm": ">=6.0.0"
  },
  "installed": false,
  "installedAt": null
}
```

**更新注册表索引**:

**文件路径**: `registry/index.json`

**操作**: 在 `plugins` 数组中添加 figma 引用

```json
{
  "version": "1.0.0",
  "lastUpdated": "2025-01-21",
  "plugins": [
    {
      "id": "git-commit",
      "name": "Git Commit",
      "file": "git-commit.json"
    },
    {
      "id": "figma",
      "name": "Figma 设计稿转代码",
      "file": "figma.json"
    }
  ]
}
```

**验证**:
```bash
cat registry/index.json | jq .
# 应该看到更新后的插件列表
cat registry/figma.json | jq .
# 应该看到完整的 figma 注册表文件
```

---

### 步骤 12: 测试插件

**测试清单**:

1. **目录结构测试**:
   ```bash
   # 验证所有文件和目录存在
   ls -la .claude-plugin/plugins/figma/.claude-plugin/
   ls -la .claude-plugin/plugins/figma/commands/
   ls -la .claude-plugin/plugins/figma/scripts/
   ```

2. **配置文件测试**:
   ```bash
   # 验证 JSON 格式
   cat .claude-plugin/plugins/figma/.claude-plugin/plugin.json | jq .
   cat .claude-plugin/plugins/figma/.claude-plugin/.mcp.json | jq .
   cat registry/figma.json | jq .
   ```

3. **脚本测试**:
   ```bash
   # 测试框架检测脚本
   node .claude-plugin/plugins/figma/scripts/detect-framework.js
   ```

4. **功能测试**:
   - 在 Claude Code 中执行: `/figma https://www.figma.com/file/xxxxx/Test`
   - 验证是否正确检测项目框架
   - 验证是否生成代码文件
   - 验证生成的代码质量

5. **集成测试**:
   - 测试 MCP 连接
   - 测试技能自动加载
   - 测试命令执行

---

## 文件清单

完成所有步骤后，应该创建以下文件：

```
✅ .claude-plugin/plugins/figma/.claude-plugin/plugin.json
✅ .claude-plugin/plugins/figma/.claude-plugin/.mcp.json
✅ .claude-plugin/plugins/figma/SKILL.md
✅ .claude-plugin/plugins/figma/README.md
✅ .claude-plugin/plugins/figma/commands/to-code.md
✅ .claude-plugin/plugins/figma/scripts/detect-framework.js
✅ .claude-plugin/plugins/figma/scripts/install.sh
✅ .claude-plugin/plugins/figma/scripts/uninstall.sh
✅ registry/figma.json
✅ registry/index.json (已更新)
✅ .claude-plugin/marketplace.json (已更新)
```

---

## 验证命令

### 快速验证

```bash
# 1. 检查所有文件是否存在
find .claude-plugin/plugins/figma -type f | sort

# 2. 验证 JSON 文件格式
for file in .claude-plugin/plugins/figma/.claude-plugin/*.json registry/figma.json; do
  echo "验证 $file"
  jq . "$file" > /dev/null && echo "✅ 格式正确" || echo "❌ 格式错误"
done

# 3. 验证脚本可执行
ls -la .claude-plugin/plugins/figma/scripts/*.sh

# 4. 测试框架检测
node .claude-plugin/plugins/figma/scripts/detect-framework.js

# 5. 查看插件配置
cat .claude-plugin/marketplace.json | jq .plugins[]
```

---

## 后续优化建议

1. **增强框架检测**:
   - 支持更多框架（Qwik、Astro、SolidStart 等）
   - 检测项目特定配置（如 vite.config.ts、next.config.js 等）

2. **代码生成优化**:
   - 添加更多代码模板
   - 支持自定义代码生成规则
   - 添加代码格式化和 linting

3. **交互优化**:
   - 添加进度提示
   - 支持交互式配置
   - 添加预览功能

4. **测试覆盖**:
   - 添加单元测试
   - 添加集成测试
   - 添加 E2E 测试

5. **文档完善**:
   - 添加更多示例
   - 添加故障排除指南
   - 添加视频教程

---

## 注意事项

1. **API Key 安全**:
   - 当前 API Key 已硬编码在配置中
   - 建议改为环境变量或用户配置
   - 添加 API Key 验证逻辑

2. **错误处理**:
   - 添加完善的错误处理
   - 提供清晰的错误消息
   - 添加重试机制

3. **性能优化**:
   - 缓存设计数据
   - 优化生成速度
   - 支持增量更新

4. **可扩展性**:
   - 设计插件化架构
   - 支持自定义扩展
   - 提供插件 API

---

## 总结

本实施计划提供了完整的步骤来创建一个功能完善的 Figma 设计稿转代码插件。按照此计划执行，你将获得：

✨ 一个可以自动识别项目技术栈的插件
🎨 高度还原 Figma 设计稿的代码生成能力
📦 支持多种主流前端框架和 UI 库
🔧 自动遵循项目代码规范
📝 完整的文档和测试

预计实施时间：2-3 小时
