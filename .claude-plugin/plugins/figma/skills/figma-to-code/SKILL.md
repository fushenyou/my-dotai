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

## 工作流程

### 1. 分析项目环境

首先检测项目的技术栈，检测项包括：
- **前端框架**: React、Vue、Svelte、Angular、Solid
- **UI 库**: shadcn/ui、Material-UI、Ant Design、Chakra UI、Radix UI
- **样式方案**: Tailwind CSS、CSS Modules、Styled Components、Emotion
- **TypeScript**: 是否使用 TypeScript
- **路由系统**: React Router、Vue Router 等
- **状态管理**: Redux、Zustand、Pinia 等

### 2. 获取 Figma 设计数据

通过 MCP 工具调用 figma-developer-mcp 获取：
- 设计稿布局结构
- 组件层级关系
- 样式属性（颜色、字体、间距等）
- 响应式断点
- 交互状态

如果存在图片资源，询问后使用 download_figma_images 工具下载图片。

### 3. 生成组件代码

根据检测到的框架和规范生成代码。

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

## 最佳实践

1. **保持代码简洁**: 避免过度抽象，优先直接实现
2. **复用现有组件**: 检测项目中已有的 UI 组件并复用
3. **响应式设计**: 根据 Figma 的自适应布局生成响应式代码
4. **可访问性**: 添加必要的 ARIA 属性和语义化标签
5. **性能优化**: 使用懒加载、代码分割等优化策略

## 故障排除

### MCP 连接失败
- 检查 API Key 是否有效
- 确认 figma-developer-mcp 已正确安装
- 查看错误日志获取详细信息

### 框架检测错误
- 手动指定框架：`使用 React + Tailwind CSS 实现`
- 检查 package.json 中的依赖

### 生成的代码不符合规范
- 提供现有组件作为参考
- 明确指定编码规范要求
