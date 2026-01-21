---
description: 从 Figma 设计稿生成代码
---

# /figma - Figma 设计稿转代码

当用户使用 `/figma` 命令时，按照以下步骤执行：

## 执行步骤

1. **获取 Figma URL**：从用户输入中提取 Figma 文件 URL 或节点 ID
2. **检测项目框架**：分析 package.json 检测前端框架和 UI 库
3. **调用 MCP 工具**：使用 `figma` MCP 服务器的工具获取设计数据
   - 使用 `get_figma_data` 或类似工具获取设计稿信息
   - 如果需要图片，使用 `download_figma_images` 工具
4. **生成代码**：根据检测到的框架和设计数据生成组件代码
5. **创建文件**：将生成的代码写入项目适当位置

## 重要提示

- **必须使用 MCP 工具**：通过 `figma` MCP 服务器提供的工具获取设计数据
- **API Key 配置**：确保在环境变量中设置了 `FIGMA_ACCESS_TOKEN`
- **权限检查**：确保 Figma 文件已公开或 token 有访问权限

## 示例用法

### 基础用法
```
/figma https://www.figma.com/file/xxxxx/Design-System
```

### 指定目标路径
```
/figma https://www.figma.com/file/xxxxx/Component
生成到 src/components/Button.tsx
```

### 指定框架
```
/figma https://www.figma.com/file/xxxxx/Page
使用 React + Tailwind CSS
```

## 框架检测逻辑

检查 package.json 中的依赖：
- React: dependencies.react
- Vue: dependencies.vue
- Svelte: dependencies.svelte
- Angular: dependencies.@angular/core
- UI 库：tailwindcss, @mui/material, antd 等

## 输出要求

- 生成的代码必须符合项目现有风格
- 使用 TypeScript 如果项目已配置
- 遵循项目的目录结构
- 添加适当的注释和类型定义
