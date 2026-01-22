# Figma Code Generator

通过 Figma MCP 工具自动生成代码的 Claude Code 插件。支持从 Figma 设计文件创建页面和可复用组件，遵循项目现有的代码规范和框架约定。

## 功能特性

- ✨ **智能代码生成**：从 Figma 设计文件自动生成高质量代码
- 🎯 **双模式支持**：
  - 页面模式（`--page`）：创建完整的页面文件
  - 组件模式（`--component`）：创建可复用的组件
- 🔍 **项目规范识别**：自动检测项目框架和代码规范
- 🎨 **完整设计数据**：获取布局、内容、视觉效果和组件信息
- 🖼️ **图片资源下载**：自动下载设计中的 SVG 和 PNG 图片
- 📝 **TypeScript 支持**：生成完整的类型定义
- 🎓 **最佳实践**：遵循 Cursor 和 Claude 的代码生成规范

## 安装

### 方式一：从 Marketplace 安装

在 Claude Code 中搜索并安装 `figma` 插件。

### 方式二：手动安装

\`\`\`bash
cd ~/.claude/plugins
git clone https://github.com/your-username/figma-plugin.git figma
\`\`\`

## 前置要求

1. **Node.js 和 npm**：确保已安装 Node.js
2. **Figma 访问权限**：确保 Figma 文件是公开的或已授权访问
3. **MCP 服务器配置**：插件会自动配置 `figma-developer-mcp` MCP 服务器

## 使用方法

### 基本语法

\`\`\`
/figma:to-code <Figma URL> [选项]
\`\`\`

### 创建页面

从 Figma 设计创建完整的页面：

\`\`\`
/figma:to-code https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --page
\`\`\`

**输出**：
- 完整的页面组件
- 响应式布局
- 样式文件
- 类型定义

### 创建组件

从 Figma 设计创建可复用的组件：

\`\`\`
/figma:to-code https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --component
\`\`\`

**输出**：
- 可复用的组件
- Props 接口定义
- 多种配置选项（variant、size 等）
- 使用示例

## 参数说明

### 必需参数

- `<Figma URL>`：Figma 设计文件的完整 URL

### 可选选项

- `--page`：创建页面模式
- `--component`：创建组件模式

## 配置

### MCP 服务器

插件会自动配置 `figma-developer-mcp` MCP 服务器：

\`\`\`json
{
  "mcpServers": {
    "figma-developer-mcp": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp"]
    }
  }
}
\`\`\`

### Claude Code 配置

在 Claude Code 中使用此插件需要手动配置 MCP 服务器：

#### 配置文件位置

- **macOS/Linux**: `~/.claude.json`

#### 配置步骤

1. **创建或编辑配置文件**：

\`\`\`bash
# macOS/Linux
nano ~/.claudejson

\`\`\`

2. **添加以下配置**：

\`\`\`json
{
  "mcpServers": {
    "figma-developer-mcp": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp", "--stdio"]
    }
  }
}
\`\`\`

3. **保存文件并重启 Claude Code**

4. **验证配置**：

运行以下命令确认 MCP 服务器已正确加载：

\`\`\`bash
claude mcp list
\`\`\`

你应该能看到 `figma-developer-mcp` 在服务器列表中。

#### 通用注意事项

1. **Node.js 版本**：确保已安装 Node.js 18 或更高版本
2. **网络连接**：首次运行时会自动下载 `figma-developer-mcp` 包，需要网络连接
3. **权限问题**：如果遇到权限错误，可能需要使用 `sudo`（仅限 macOS/Linux）
4. **npx 缓存**：如果遇到问题，可以尝试清除 npx 缓存：`npx clear-npx-cache`

### 项目规范识别

插件会自动检测：

1. **框架类型**：React、Vue、Next.js 等
2. **TypeScript 配置**：`tsconfig.json`
3. **样式方案**：CSS Modules、Tailwind、styled-components 等
4. **代码风格**：ESLint、Prettier 配置

## 工作原理

### 第一步：获取 Figma 数据

使用 `figma-developer-mcp` MCP 工具：

1. **get_figma_data**：获取完整的设计数据
   - 布局信息（frames、groups、components）
   - 内容信息（text、images、icons）
   - 视觉效果（colors、gradients、shadows）
   - 组件层次结构

2. **download_figma_images**：下载图片资源
   - SVG 和 PNG 格式
   - 图标、插图等

### 第二步：分析项目规范

- 读取 `package.json` 确定框架
- 检查 TypeScript 配置
- 分析现有代码风格
- 确定样式方案

### 第三步：生成代码

根据选择的模式生成代码：

- **页面模式**：完整的页面组件，包含布局和样式
- **组件模式**：可复用的组件，包含 Props 接口和配置选项

## 示例

### 页面模式示例

**输入**：
\`\`\`
/figma:to-code https://www.figma.com/site/.../App-Download?node-id=2-303 --page
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
/figma:to-code https://www.figma.com/site/.../App-Download?node-id=2-303 --component
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

## 项目结构

\`\`\`
figma/
├── .claude-plugin/
│   └── plugin.json           # 插件配置
├── commands/
│   └── to-code.md            # to-code 命令
├── skills/
│   └── figma-code-gen/
│       └── SKILL.md          # 代码生成技能
└── README.md                 # 插件文档
\`\`\`

## 开发

### 本地测试

\`\`\`bash
# 进入插件目录
cd ~/.claude/plugins/figma

# 测试命令
/figma:to-code https://www.figma.com/... --page
\`\`\`

### 调试

使用调试模式运行 Claude Code：

\`\`\`bash
claude --debug
\`\`\`

查看输出中的插件加载信息和错误。

## 故障排除

### MCP 服务器未启动

\`\`\`
错误：figma-developer-mcp MCP 服务器未配置
\`\`\`

**解决方法**：
1. 检查 `plugin.json` 中的 MCP 服务器配置
2. 确保 Node.js 和 npm 已安装
3. 手动安装：`npm install -g figma-developer-mcp`

### Figma URL 无效

\`\`\`
错误：无法解析 Figma URL
\`\`\`

**解决方法**：
- 确保提供完整的 Figma URL
- URL 应包含 `file_id` 和 `node_id`
- 确保 Figma 文件有访问权限

### 项目规范未检测

\`\`\`
警告：无法确定项目框架，使用默认配置
\`\`\`

**解决方法**：
- 确保 `package.json` 存在
- 检查项目中的框架依赖
- 手动指定框架和样式方案

## 最佳实践

### 设计规范

1. **命名规范**：
   - 使用有意义的组件名称
   - 遵循项目的命名约定

2. **组件设计**：
   - 保持组件单一职责
   - 提供合理的 Props 默认值
   - 支持样式自定义

3. **代码质量**：
   - 使用 TypeScript 定义类型
   - 添加 JSDoc 注释
   - 保持代码简洁清晰

### 工作流建议

1. **先创建组件**：从可复用的组件开始
2. **再组合页面**：使用组件构建完整页面
3. **审查和测试**：检查生成的代码并进行测试
4. **迭代优化**：根据需要调整和优化

## 路线图

- [ ] 支持更多框架（Svelte、Angular 等）
- [ ] 支持更多样式方案（CSS-in-JS、SCSS 等）
- [ ] 添加组件库集成（Material-UI、Ant Design 等）
- [ ] 支持批量生成多个组件
- [ ] 添加交互设计生成（动画、过渡等）
- [ ] 支持自定义代码模板

## 贡献

欢迎贡献！请随时提交 Issue 或 Pull Request。

## 许可证

MIT License - 详见 LICENSE 文件

## 作者

## 致谢

- [Claude Code](https://github.com/anthropics/claude-code)
- [figma-developer-mcp](https://github.com/figma-developer-mcp)
- 所有贡献者

---

**插件版本**：0.1.0
**最后更新**：2025-01-21
