---
description: 分析当前项目的代码架构和框架设计，生成结构化文档
---

# /code-analyzer:analyze - 代码架构分析

**重要：本命令必须使用 `code-analyze` 技能执行分析。**

调用本命令时，必须按照 `skills/analyze/SKILL.md` 中定义的技能流程执行分析，并使用 `references/report-template.md` 模板生成报告。

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

严格按照 `skills/analyze/SKILL.md` 定义的四个阶段执行：

1. **第一阶段：快速扫描** — 识别项目类型、扫描目录结构、读取关键文件
2. **第二阶段：深度分析** — 根据项目类型选择分析维度（分层架构、模块通信、数据流等）
3. **第三阶段：交互确认** — 使用 AskUserQuestion 与用户确认：
   - 分析范围（全局概览 or 聚焦模块）
   - 分析深度（精简速览 or 详细展开）
   - 图表需求（Excalidraw 架构图 / Mermaid 流程图）
   - **输出目录**（自动检测 Obsidian 笔记库路径，若无法确定则必须询问用户）
4. **第四阶段：生成报告** — 使用 `references/report-template.md` 模板，写入用户确认的 Obsidian 目录

## 报告模板

分析报告必须遵循 `skills/analyze/references/report-template.md` 的结构，包含：
速览卡片、技术栈、架构全景、核心模块、数据流、设计模式与亮点、推荐阅读路径。

## 图表生成

- 架构图、模块关系图 → 调用 `obsidian-visual-skills:excalidraw-diagram`
- 流程图、时序图、类图 → 调用 `obsidian-visual-skills:mermaid-visualizer`

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

- 分析报告：保存到用户确认的 Obsidian 笔记库 `代码分析/` 子目录下
- 架构图：与报告同目录下的 Excalidraw 或 Mermaid 文件
- **注意**：输出路径通过交互确认确定，不使用硬编码路径
