---
description: 分析当前项目的代码架构和框架设计，生成结构化文档
---

# /code-analyzer:analyze - 代码架构分析

分析当前项目的代码架构和框架设计思路，生成结构化分析文档保存到 Obsidian 笔记库。

## 使用方法

```
/code-analyzer:analyze [项目路径] [选项]
```

## 参数

- `[项目路径]`: 要分析的项目目录路径（默认为当前工作目录）

## 选项

- `--quick`: 仅生成速览卡片，跳过详细分析
- `--module <模块名>`: 聚焦分析指定模块
- `--no-diagram`: 不生成图表

## 执行步骤

1. **识别项目** — 检测技术栈、规模和项目类型
2. **扫描结构** — 分析目录布局、入口文件和核心模块
3. **交互确认** — 与用户确认分析方向和深度
4. **深度分析** — 解读架构设计决策和模块间关系
5. **生成图表** — 架构图用 Excalidraw，流程图用 Mermaid
6. **输出报告** — 保存到 Obsidian 笔记库

## 示例

```
# 分析当前项目
/code-analyzer:analyze

# 分析指定项目
/code-analyzer:analyze /path/to/project

# 快速速览
/code-analyzer:analyze --quick

# 聚焦分析某个模块
/code-analyzer:analyze --module auth
```

## 输出

- 分析报告：保存到 `/Users/fusy/workspace/ObsidianVault/NoteBooks/note/代码分析/{项目名}-架构分析.md`
- 架构图：与报告同目录下的 Excalidraw 或 Mermaid 文件
