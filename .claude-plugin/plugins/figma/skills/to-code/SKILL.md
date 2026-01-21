---
name: figma-code-gen
description: 从 Figma 设计文件自动生成代码，支持创建页面和可复用组件
alwaysApply: false
---

# figma-code-gen - Figma 代码生成技能

## 概述

此技能通过 figma-developer-mcp MCP 工具从 Figma 设计文件获取完整的设计数据，并根据项目现有的代码规范和框架约定生成高质量代码。

核心原则：
- 遵循项目现有的代码规范和框架约定
- 生成可维护、可复用的代码
- 支持页面和组件两种生成模式
- 参考 Cursor 和 Claude 的代码生成最佳实践

## 何时使用

**使用此技能当**：
- 用户通过 `/figma:to-code` 命令提供 Figma URL
- 需要从 Figma 设计生成前端代码
- 需要创建页面（使用 `--page` 标志）
- 需要创建可复用组件（使用 `--component` 标志）

**跳过此技能当**：
- ❌ 没有 Figma URL
- ❌ 仅需要分析设计而不生成代码
- ❌ 用户明确要求不使用此技能

## 执行流程

### 第一步：验证和准备

1. **解析输入参数**
   ```bash
   $ARGUMENTS = "<Figma URL> [--page|--component]"
   ```

2. **提取 Figma 文件 ID 和节点 ID**
   - 从 URL 中提取文件 ID（格式：`/site/{FILE_ID}/`）
   - 提取节点 ID（`node-id` 参数）
   - 验证 URL 格式是否正确

3. **确定生成模式**
   - 检测 `--page` 或 `--component` 标志
   - 如果都没有，默认为页面模式

### 第二步：获取 Figma 数据

使用 figma-developer-mcp MCP 工具获取设计数据：

\`\`\`
# 1. 获取全面的 Figma 文件数据
mcp__figma-developer-mcp__get_figma_data
  file_id: "<FILE_ID>"
  node_id: "<NODE_ID>"

# 2. （可选）下载设计中的图片和图标
mcp__figma-developer-mcp__download_figma_images
  file_id: "<FILE_ID>"
  image_ids: ["<IMAGE_ID_1>", "<IMAGE_ID_2>", ...]
\`\`\`

**MCP 工具说明**：

1. **get_figma_data**：获取全面的 Figma 文件数据，包括：
   - 完整的布局信息（frames、groups、components）
   - 内容信息（text、images、icons）
   - 视觉效果（colors、gradients、shadows、effects）
   - 组件层次结构和关系
   - 响应式约束和自动布局

2. **download_figma_images**：根据节点 ID 下载 Figma 文件中的图片：
   - 支持 SVG 和 PNG 格式
   - 适用于图标、插图和其他图片资源
   - 返回下载的文件路径

### 第三步：分析项目规范

1. **检测项目框架**
   - 读取 `package.json` 确定框架（React、Vue、Next.js 等）
   - 检查 TypeScript 配置（`tsconfig.json`）
   - 确定样式方案（CSS Modules、Tailwind、styled-components 等）

2. **分析现有代码规范**
   - 查看项目中的类似组件
   - 了解命名约定
   - 确定文件组织结构
   - 参考 Cursor/Claude 的代码生成规则（如果存在）

3. **确定导入和依赖**
   - 需要的 UI 库组件
   - 工具函数和辅助方法
   - 类型定义（TypeScript）

### 第四步：生成代码

#### 页面模式（--page）

创建完整的页面文件：

1. **确定页面结构**
   \`\`\`typescript
   // pages/或 app/ 目录下的新页面
   // 或组件目录下的页面组件
   \`\`\`

2. **生成页面代码**
   - 完整的组件结构
   - 布局和样式
   - 数据获取逻辑（如果需要）
   - 响应式设计

3. **创建辅助文件**（如需要）
   - 样式文件
   - 类型定义
   - 数据模型

#### 组件模式（--component）

创建可复用的组件：

1. **设计组件接口**
   \`\`\`typescript
   interface Props {
     // 必需属性
     title: string;
     content: string;

     // 可选属性
     variant?: 'primary' | 'secondary';
     size?: 'sm' | 'md' | 'lg';
     className?: string;
     onClick?: () => void;
   }
   \`\`\`

2. **考虑组件的复用性**
   - Props 设计：提供灵活的配置选项
   - 样式自定义：支持 className 和 variant
   - 响应式：适应不同屏幕尺寸
   - 可访问性：添加 ARIA 属性和键盘支持

3. **生成组件代码**
   - 组件实现
   - TypeScript 类型定义
   - 样式（使用项目的样式方案）
   - JSDoc 注释

4. **创建示例用法**
   \`\`\`typescript
   // 示例：如何使用这个组件
   <MyComponent
     title="示例标题"
     content="示例内容"
     variant="primary"
     size="md"
   />
   \`\`\`

### 第五步：输出和说明

1. **展示生成的代码**
   - 使用代码块展示完整代码
   - 说明文件路径
   - 解释关键设计决策

2. **提供使用说明**
   - 如何导入和使用
   - 依赖的库和组件
   - 需要的手动调整（如有）

3. **建议后续步骤**
   - 需要添加的功能
   - 测试建议
   - 优化建议

## 最佳实践

### 代码质量

- **类型安全**：使用 TypeScript 定义清晰的类型
- **可读性**：使用有意义的变量和函数名
- **可维护性**：保持组件单一职责
- **性能**：避免不必要的重渲染

### 组件设计

- **Props 设计**：
  - 必需属性 vs 可选属性
  - 提供合理的默认值
  - 使用枚举限制选项

- **样式组织**：
  - 使用项目的样式方案
  - 保持样式一致性
  - 支持主题定制（如适用）

- **响应式设计**：
  - 使用相对单位（rem、em、%）
  - 添加断点
  - 测试不同屏幕尺寸

### 项目集成

- **文件结构**：遵循项目的组织规范
- **命名约定**：匹配项目现有的命名风格
- **导入路径**：使用项目配置的路径别名
- **代码风格**：匹配项目的 ESLint/Prettier 配置

## 错误处理

### 常见问题

1. **MCP 工具不可用**
   ```
   错误：figma-developer-mcp MCP 服务器未配置
   解决：请先在 plugin.json 中配置 MCP 服务器
   ```

2. **Figma URL 无效**
   ```
   错误：无法解析 Figma URL
   解决：请提供完整的 Figma URL，包含 file_id 和 node_id
   ```

3. **项目规范未检测**
   ```
   警告：无法确定项目框架，使用默认配置
   解决：手动指定框架和样式方案
   ```

### 降级策略

- 如果无法获取完整数据，使用可用的部分数据
- 如果无法检测项目规范，使用通用最佳实践
- 在代码注释中说明假设和限制

## 示例

### 页面模式示例

**输入**：
\`\`\`
/figma:to-code https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --page
\`\`\`

**输出**：
\`\`\`typescript
// app/download-page.tsx
import React from 'react';

export default function DownloadPage() {
  return (
    <div className="download-page">
      {/* 页面内容 */}
    </div>
  );
}
\`\`\`

### 组件模式示例

**输入**：
\`\`\`
/figma:to-code https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --component
\`\`\`

**输出**：
\`\`\`typescript
// components/DownloadCard.tsx
import React from 'react';

interface DownloadCardProps {
  title: string;
  description: string;
  icon?: React.ReactNode;
  variant?: 'primary' | 'secondary';
  onClick?: () => void;
}

export function DownloadCard({
  title,
  description,
  icon,
  variant = 'primary',
  onClick,
}: DownloadCardProps) {
  return (
    <div className={`download-card download-card--${variant}`} onClick={onClick}>
      {icon && <div className="download-card__icon">{icon}</div>}
      <h3 className="download-card__title">{title}</h3>
      <p className="download-card__description">{description}</p>
    </div>
  );
}
\`\`\`

## 技术参考

### MCP 工具

- **figma-developer-mcp**：
  - 获取 Figma 文件的完整设计数据
  - 包括布局、内容、视觉效果和组件信息
  - 支持节点级别的数据提取

### 代码生成参考

- **Cursor AI 代码生成**：
  - 遵循项目的代码风格
  - 生成可维护的代码
  - 使用最佳实践

- **Claude Code 规范**：
  - 清晰的代码结构
  - 完整的类型定义
  - 详细的注释和文档

## 注意事项

1. **Figma 访问权限**：确保 Figma 文件是公开的或已授权访问
2. **MCP 服务器配置**：确保 figma-developer-mcp 已正确配置
3. **项目兼容性**：生成的代码可能与项目的具体实现需要调整
4. **代码审查**：生成代码后应进行审查和测试
5. **版本控制**：在提交前仔细检查生成的代码

## 持续改进

此技能将不断优化：
- 支持更多框架和样式方案
- 改进组件的复用性
- 增强代码质量
- 提供更多自定义选项

---

**技能版本**：0.1.0
**最后更新**：2025-01-21
