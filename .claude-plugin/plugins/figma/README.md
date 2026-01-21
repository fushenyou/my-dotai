# Figma Plugin

> 将 Figma 设计稿转换为高质量前端代码，高度还原设计细节

## 概述

Figma 插件通过 figma-developer-mcp 获取 Figma 设计稿的详细信息，智能分析布局、样式、组件等设计要素，生成符合设计规范的前端代码。让设计到开发的转换变得简单、快速、准确。

## 功能特性

### 🎯 高精度还原
- 提取准确的尺寸、间距、颜色
- 还原字体、圆角、阴影等细节
- 识别渐变、透明度等高级效果
- 支持复杂布局（Auto Layout、Grid）

### 🚀 多框架支持
- React + TypeScript
- Vue 3 + TypeScript
- HTML + CSS
- 可扩展支持其他框架

### 🎨 多样式方案
- Tailwind CSS（推荐）
- CSS Modules
- Styled Components
- 原生 CSS

### 📦 智能分析
- 自动识别组件层级结构
- 提取设计 tokens（颜色、间距、字体）
- 检测响应式设计规范
- 识别可复用组件

### 🔧 开发者友好
- 生成类型安全的 TypeScript 代码
- 遵循最佳实践和代码规范
- 提供完整的使用文档
- 支持组件化思维

## 安装

### 前置要求

插件会自动配置 MCP 服务器，但你需要：

1. **获取 Figma Access Token**

   访问 [Figma Developer Settings](https://www.figma.com/developers/api#access-tokens) 创建个人访问令牌。
   - 标准格式：`figd_xxxxx...`（Personal Access Token）
   - 脚本也支持其他格式，只要 Token 有效即可

2. **在安装时配置 Token**

   安装插件时，脚本会提示你输入 Figma Access Token。

   **macOS/Linux 用户**：
   ```bash
   bash .claude-plugin/plugins/figma/install.sh
   ```

   **Windows 用户**：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .claude-plugin/plugins/figma/install.ps1
   ```

   脚本会自动：
   - 验证 API Key 格式
   - 添加到 `~/.claude/settings.json`
   - 启用 Figma 插件

### 手动配置（可选）

如果你想手动配置，可以：

1. **安装 figma-developer-mcp**
```bash
npm install -g figma-developer-mcp
```

2. **配置 Figma Access Token**

从 [Figma Account Settings](https://www.figma.com/settings) 获取 Access Token，然后设置环境变量：
```bash
# macOS/Linux
export FIGMA_ACCESS_TOKEN="your_figma_token_here"

# Windows (PowerShell)
$env:FIGMA_ACCESS_TOKEN="your_figma_token_here"

# 或添加到 ~/.bashrc 或 ~/.zshrc
echo 'export FIGMA_ACCESS_TOKEN="your_figma_token_here"' >> ~/.zshrc
```

### 安装插件

#### 方式一：从 GitHub 仓库安装（推荐）

1. **克隆或下载仓库**
```bash
git clone https://github.com/fushenyou/my-dotai.git
cd my-dotai
```

2. **运行配置脚本**

**macOS/Linux**：
```bash
bash .claude-plugin/plugins/figma/install.sh your_figma_access_token
```

**Windows**：
```powershell
powershell -ExecutionPolicy Bypass -File .claude-plugin/plugins/figma/install.ps1 -FigmaApiKey "your_figma_access_token"
```

3. **重启 Claude Code**

#### 方式二：手动安装

1. 将插件目录复制到你的项目：
```bash
# 在你的项目根目录
mkdir -p .claude-plugin/plugins/figma
cp -r /path/to/my-dotai/.claude-plugin/plugins/figma/* .claude-plugin/plugins/figma/
```

2. 运行配置脚本：

**macOS/Linux**：
```bash
bash .claude-plugin/plugins/figma/install.sh your_figma_access_token
```

**Windows**：
```powershell
powershell -ExecutionPolicy Bypass -File .claude-plugin/plugins/figma/install.ps1 -FigmaApiKey "your_figma_access_token"
```

3. 重启 Claude Code

### 验证安装

安装完成后，你可以验证 MCP 配置是否成功：

```bash
# 查看 Claude Code 配置
cat ~/.claude/settings.json
```

你应该能看到：
```json
{
  "env": {
    "FIGMA_ACCESS_TOKEN": "figd_..."
  },
  "enabledPlugins": {
    "figma@my-dotai": true
  }
}
```

## 使用

### 基本使用

在 Claude Code 中执行：

```bash
/figma:design-to-code
```

然后提供 Figma URL，例如：
```
请将这个 Figma 设计稿转换为 React + Tailwind 代码：
https://www.figma.com/file/xxxxx
```

### 使用场景

#### 1. 页面开发
```
设计稿：完整的登录页面
输出：React 组件 + Tailwind 样式
结果：1:1 还原设计的可运行代码
```

#### 2. 组件提取
```
设计稿：UI 组件库（按钮、卡片、表单等）
输出：可复用的 React 组件
结果：完整的组件库代码
```

#### 3. 响应式布局
```
设计稿：桌面端和移动端设计
输出：响应式组件代码
结果：自动适配不同屏幕尺寸
```

#### 4. 设计系统迁移
```
设计稿：设计系统规范
输出：Design tokens 文件 + 组件代码
结果：可直接使用的设计系统
```

## 工作流程

```
Figma 设计稿 → figma-developer-mcp → 分析设计 → 生成代码 → 可运行的前端组件
```

### 详细步骤

1. **提供 Figma URL**
   - 确保设计稿可访问
   - 可以是整个文件或特定节点

2. **自动获取设计信息**
   - 使用 figma-developer-mcp 获取设计数据
   - 解析组件层级和样式属性

3. **智能分析设计**
   - 识别布局结构
   - 提取颜色、字体、间距
   - 检测可复用元素

4. **生成前端代码**
   - 根据选择的框架生成代码
   - 应用相应的样式方案
   - 保留设计的所有细节

5. **输出完整代码**
   - 组件代码
   - 样式定义
   - 使用说明

## 示例

### 示例 1：登录表单

**输入**：
```
Figma URL: https://www.figma.com/file/xxxxx/login-page
框架: React + Tailwind
```

**输出**：
```tsx
import React from 'react'
import { cn } from '@/lib/utils'

interface LoginFormProps {
  className?: string
  onSubmit?: (data: { email: string; password: string }) => void
}

export function LoginForm({ className, onSubmit }: LoginFormProps) {
  return (
    <div className={cn('w-full max-w-md p-8 bg-white rounded-2xl shadow-lg', className)}>
      <h2 className="text-2xl font-semibold text-gray-900 mb-6">
        欢迎回来
      </h2>
      <form className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            邮箱
          </label>
          <input
            type="email"
            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            placeholder="your@email.com"
          />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            密码
          </label>
          <input
            type="password"
            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            placeholder="••••••••"
          />
        </div>
        <button
          type="submit"
          className="w-full bg-blue-600 text-white py-3 rounded-lg font-medium hover:bg-blue-700 transition-colors"
        >
          登录
        </button>
      </form>
    </div>
  )
}
```

### 示例 2：卡片组件

**输入**：
```
Figma URL: https://www.figma.com/file/xxxxx/card-component
要求：支持多种变体
```

**输出**：
```tsx
import React from 'react'
import { cn } from '@/lib/utils'

interface CardProps {
  title: string
  description: string
  image?: string
  variant?: 'default' | 'outlined' | 'elevated'
  className?: string
}

export function Card({
  title,
  description,
  image,
  variant = 'default',
  className,
}: CardProps) {
  return (
    <div
      className={cn(
        'rounded-xl overflow-hidden',
        {
          'bg-white shadow-md': variant === 'default',
          'bg-white border-2 border-gray-200': variant === 'outlined',
          'bg-white shadow-xl': variant === 'elevated',
        },
        className
      )}
    >
      {image && (
        <img src={image} alt={title} className="w-full h-48 object-cover" />
      )}
      <div className="p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-2">
          {title}
        </h3>
        <p className="text-gray-600">{description}</p>
      </div>
    </div>
  )
}
```

## 高级功能

### 1. Design Tokens 提取

自动提取设计稿中的设计规范：

```typescript
// tokens.ts
export const tokens = {
  colors: {
    primary: {
      50: '#EFF6FF',
      100: '#DBEAFE',
      500: '#3B82F6',
      600: '#2563EB',
      900: '#1E3A8A',
    },
    gray: {
      50: '#F9FAFB',
      100: '#F3F4F6',
      900: '#111827',
    },
  },
  spacing: {
    xs: '4px',
    sm: '8px',
    md: '16px',
    lg: '24px',
    xl: '32px',
  },
  fonts: {
    sans: 'Inter, system-ui, sans-serif',
    heading: 'Poppins, sans-serif',
  },
}
```

### 2. 响应式设计

自动识别并生成响应式代码：

```tsx
<div className="
  grid
  grid-cols-1
  md:grid-cols-2
  lg:grid-cols-3
  gap-6
">
  {/* 卡片列表 */}
</div>
```

### 3. 组件变体

识别设计稿中的组件变体：

```tsx
// Button 组件的多种状态
<Button variant="primary">主要按钮</Button>
<Button variant="secondary">次要按钮</Button>
<Button variant="outline">轮廓按钮</Button>
<Button variant="ghost">幽灵按钮</Button>
```

### 4. 国际化支持

自动提取文本内容，支持多语言：

```typescript
const i18n = {
  en: {
    login: 'Login',
    email: 'Email',
    password: 'Password',
  },
  zh: {
    login: '登录',
    email: '邮箱',
    password: '密码',
  },
}
```

## 最佳实践

### 1. 设计稿准备

在 Figma 中：
- ✅ 使用 Auto Layout 进行布局
- ✅ 命名规范且清晰
- ✅ 使用组件（Components）和变体（Variants）
- ✅ 设置正确的 Constraints
- ✅ 规范使用颜色和字体样式

### 2. 组件命名

- 使用 PascalCase：`Button`, `LoginForm`, `Card`
- 描述性命名：`PrimaryButton`, `OutlinedButton`
- 避免缩写：`Navigation` 而不是 `Nav`

### 3. 代码组织

- 每个组件一个文件
- 使用类型定义 Props
- 导出设计 tokens
- 编写使用示例

### 4. 性能优化

- 使用 React.memo 避免不必要的重渲染
- 图片懒加载
- CSS 按需导入
- 避免深层嵌套

## 故障排除

### 问题：无法获取设计稿

**可能原因**：
- Figma Access Token 无效
- 设计稿没有公开访问权限
- URL 格式不正确

**解决方案**：
```bash
# 检查 Token 是否设置
echo $FIGMA_ACCESS_TOKEN

# 重新设置 Token
export FIGMA_ACCESS_TOKEN="your_new_token"
```

### 问题：样式不匹配

**可能原因**：
- 使用了特殊字体
- 应用了 Figma 插件效果
- 设计稿使用的是 Dev Mode

**解决方案**：
- 手动调整字体设置
- 检查是否安装了必要的字体
- 对比设计稿手动微调

### 问题：图片无法加载

**可能原因**：
- 图片导出权限不足
- URL 过期

**解决方案**：
- 从 Figma 手动导出图片
- 使用本地图片路径
- 配置 CDN 加速

## 与其他工具集成

### Storybook

自动生成 Storybook stories：

```bash
npx storybook-cli add
```

生成的代码：
```typescript
// ComponentName.stories.ts
export default {
  title: 'Components/Button',
  component: Button,
}

export const Primary = {
  args: {
    variant: 'primary',
    children: 'Click me',
  },
}
```

### Jest Testing

生成组件测试：

```typescript
import { render, screen } from '@testing-library/react'
import { Button } from './Button'

test('renders button with text', () => {
  render(<Button>Click me</Button>)
  expect(screen.getByText('Click me')).toBeInTheDocument()
})
```

## 常见问题

**Q: 支持哪些 Figma 功能？**
A: 支持大部分常用功能，包括 Frames、Auto Layout、Components、Variants、Constraints、样式等。

**Q: 生成的代码可以直接用于生产吗？**
A: 生成的代码是高质量的生产级别代码，但建议根据项目需求进行调整和优化。

**Q: 如何处理复杂交互？**
A: 静态设计和基础交互可以自动生成，复杂交互逻辑需要手动编写。

**Q: 支持团队协作吗？**
A: 支持，团队成员可以使用同一个 Figma 设计稿生成一致的代码。

## 贡献

欢迎贡献！你可以：
- 报告 Bug
- 提出新功能建议
- 提交 Pull Request
- 改进文档

## 许可证

MIT License

## 作者

Created with ❤️ for Claude Code community

## 致谢

- [figma-developer-mcp](https://github.com/your-repo/figma-developer-mcp) - Figma API 集成工具
- [Figma API](https://www.figma.com/developers/api) - Figma 官方 API
