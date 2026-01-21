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
