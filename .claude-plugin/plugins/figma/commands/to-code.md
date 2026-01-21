---
description: 从 Figma 设计文件生成代码
---

# /figma:to-code - 从 Figma 生成代码

当用户使用此命令时，从 Figma 设计文件生成代码。

## 使用方法

\`\`\`
/figma:to-code <Figma URL> [选项]
\`\`\`

## 参数

- `<Figma URL>`: Figma 设计文件的完整 URL

## 选项

- `--page`: 根据链接数据创建完整的页面
- `--component`: 创建可复用的组件（考虑组件的通用性和复用性）

## 执行步骤

1. **验证输入**
   - 检查是否提供了有效的 Figma URL
   - 确定生成模式（页面或组件）

2. **获取 Figma 数据**
   - 使用 figma-developer-mcp MCP 工具获取设计数据
   - 调用：`mcp__figma-developer-mcp__get_figma_data` 或相关函数
   - 获取完整的布局、内容、视觉效果和组件信息

3. **分析项目规范**
   - 读取项目的代码规范和配置
   - 确定使用的框架（React、Vue、等）
   - 了解项目的样式方案（CSS、Tailwind、等）
   - 参考 Cursor 和 Claude 的代码生成规范

4. **生成代码**
   - 根据 Figma 数据生成对应的代码
   - **--page 模式**：创建完整的页面文件
   - **--component 模式**：创建可复用的组件，考虑：
     - Props 接口设计
     - 样式自定义能力
     - 响应式设计
     - 可配置性

5. **输出结果**
   - 展示生成的代码
   - 说明文件结构
   - 提供使用说明

## 示例

\`\`\`
# 创建页面
/figma:to-code https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --page

# 创建组件
/figma:to-code https://www.figma.com/site/JTaKVPhN8t5FDzy4ID2msv/Trustworthy-App-Download--Community-?node-id=2-303&t=LWOhD6SdldAyv4zY-4 --component
\`\`\`

## 重要提示

- 命令必须以 `/figma:to-code` 格式调用
- 使用 `$ARGUMENTS` 获取用户输入（URL 和选项）
- 确保已配置 figma-developer-mcp MCP 服务器
- 生成的代码应遵循项目现有的代码规范
