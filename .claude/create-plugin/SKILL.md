---
name: create-plugin
description: 当用户请求创建新的 Claude Code 插件时使用 - 引导用户完成插件的完整创建流程，包括目录结构、配置文件、命令、技能和钩子。确保生成的插件符合 Claude Code 插件系统的最佳实践。
---

# 创建 Claude Code 插件

## 概述

这是一个完整的 Claude Code 插件创建指南，引导用户从零开始创建符合规范的插件。

**核心原则**：遵循标准化结构，确保插件可被发现、可安装、可维护。

## 何时使用

**当用户请求以下任务时使用：**
- "创建一个新插件"
- "帮我开发一个插件"
- "实现 plugin 功能"
- "添加一个新的插件"

**不需要此技能的情况：**
- ❌ 修改现有插件（直接编辑即可）
- ❌ 简单的配置更改
- ❌ 仅添加单个命令

## 插件目录结构

**标准插件布局**：

```
{plugin-name}/
├── .claude-plugin/           # 元数据目录
│   └── plugin.json          # 必需：插件清单文件
├── commands/                 # 命令目录（可选）
│   └── command-name.md      # 命令定义文件
├── agents/                   # 代理目录（可选）
│   └── agent-name.md        # 代理定义文件
├── skills/                   # 技能目录（可选）
│   └── skill-name/
│       └── SKILL.md         # 技能定义文件
├── hooks/                    # 钩子目录（可选）
│   └── hooks.json           # 钩子配置文件
├── .mcp.json                # MCP 服务器配置（可选）
├── scripts/                 # 脚本目录（可选）
├── README.md                # 插件文档（必需）
└── LICENSE                  # 许可证文件（可选）
```

**⚠️ 关键规则**：
- `.claude-plugin/` 目录只包含 `plugin.json`
- 其他目录（commands/、agents/、skills/、hooks/）必须在插件根目录，**不在** `.claude-plugin/` 内

## 创建流程

### 第一步：收集插件信息

**必须收集的信息**：

使用 `AskUserQuestion` 工具询问以下信息（可以分批问）：

1. **插件名称**（小写，连字符分隔，如 "my-awesome-plugin"）
2. **插件描述**（简短说明插件功能）
3. **作者信息**（姓名、邮箱可选）
4. **主要功能**（插件提供什么功能？）

**可选信息**：
- 版本号（默认 "0.1.0"）
- 关键词列表
- 主页 URL
- 仓库 URL
- 许可证（默认 "MIT"）

### 第二步：创建目录结构

```bash
# 在项目根目录执行
mkdir -p .claude-plugin/plugins/{plugin-name}/.claude-plugin
mkdir -p .claude-plugin/plugins/{plugin-name}/commands
mkdir -p .claude-plugin/plugins/{plugin-name}/agents
mkdir -p .claude-plugin/plugins/{plugin-name}/skills
mkdir -p .claude-plugin/plugins/{plugin-name}/hooks
mkdir -p .claude-plugin/plugins/{plugin-name}/scripts
```

### 第三步：创建 plugin.json

**位置**：`.claude-plugin/plugins/{plugin-name}/.claude-plugin/plugin.json`

**最小配置**：

```json
{
  "name": "plugin-name",
  "version": "0.1.0",
  "description": "插件简短描述",
  "author": {
    "name": "作者名"
  }
}
```

**完整配置示例**：

```json
{
  "name": "deployment-tools",
  "version": "1.2.0",
  "description": "Deployment automation tools for CI/CD pipelines",
  "author": {
    "name": "Dev Team",
    "email": "dev@company.com"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/user/plugin",
  "license": "MIT",
  "keywords": ["deployment", "ci-cd", "automation"],
  "commands": ["./custom/cmd.md"],
  "agents": "./custom/agents/",
  "hooks": "./hooks.json",
  "mcpServers": "./mcp.json"
}
```

**字段说明**：

| 字段 | 必需 | 说明 | 示例 |
|------|------|------|------|
| `name` | ✅ | 唯一标识符（kebab-case） | `"deployment-tools"` |
| `version` | ❌ | 语义化版本号 | `"1.2.0"` |
| `description` | ❌ | 插件功能说明 | `"自动化部署工具"` |
| `author` | ❌ | 作者信息 | `{"name": "张三"}` |
| `keywords` | ❌ | 发现标签 | `["git", "github"]` |

### 第四步：创建命令（Commands）

**位置**：`commands/命令名.md`

**格式**：Markdown 文件，带 frontmatter

**示例**：

```markdown
---
description: 简短描述命令功能
---

# 命令标题

当用户使用此命令时，执行以下操作：

## 执行步骤

1. 第一步操作
2. 第二步操作
3. 第三步操作

## 重要提示

- 命令必须以 `/命令名` 格式调用
- 使用 $ARGUMENTS 获取用户输入
```

**命令文件命名规则**：
- 使用小写字母和连字符
- 名称应清晰描述命令功能
- 示例：`create-pr.md`、`deploy-app.md`

### 第五步：创建技能（Skills）

**位置**：`skills/技能名/SKILL.md`

**格式**：Markdown 文件，带 frontmatter

**示例**：

```markdown
---
name: skill-name
description: 何时使用此技能的简短描述
---

# 技能名称

## 概述

此技能的简要说明和核心原则。

## 何时使用

**使用此技能当**：
- 场景 1
- 场景 2

**跳过此技能当**：
- ❌ 不适用的场景
- ❌ 其他不适用场景

## 执行流程

1. 步骤 1
2. 步骤 2
3. 步骤 3

## 最佳实践

- 最佳实践 1
- 最佳实践 2
```

**技能命名规则**：
- 使用小写字母和连字符
- 名称应描述技能用途
- 每个技能有独立的子目录
- SKILL.md 必须大写

### 第六步：创建钩子（Hooks）

**位置**：`hooks/hooks.json`

**格式**：JSON 配置文件

**示例**：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
          }
        ]
      }
    ]
  }
}
```

**可用事件**：
- `PreToolUse` - 工具使用前
- `PostToolUse` - 工具使用后
- `UserPromptSubmit` - 用户提交提示时
- `SessionStart` - 会话开始时
- `SessionEnd` - 会话结束时
- `Stop` - 尝试停止时

**钩子类型**：
- `command` - 执行 shell 命令
- `validation` - 验证文件内容
- `notification` - 发送通知

**重要提示**：
- 使用 `${CLAUDE_PLUGIN_ROOT}` 环境变量引用插件根目录
- 脚本文件必须有执行权限（`chmod +x`）

### 第七步：创建 MCP 服务器配置（可选）

**位置**：`.mcp.json`

**格式**：标准 MCP 配置

**示例**：

```json
{
  "mcpServers": {
    "plugin-database": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "DB_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
      }
    }
  }
}
```

**关键点**：
- 所有路径使用 `${CLAUDE_PLUGIN_ROOT}`
- 相对路径必须以 `./` 开头
- 环境变量用于配置敏感信息

### 第八步：创建 README.md

**位置**：`README.md`

**必需内容**：

```markdown
# 插件名称

简短描述插件功能。

## 功能特性

- 特性 1
- 特性 2
- 特性 3

## 安装

### 方式一：从 Marketplace 安装

在 Claude Code 中搜索并安装。

### 方式二：手动安装

```bash
cd ~/.claude/plugins
git clone https://github.com/user/plugin.git
```

## 使用方法

### 命令

```
/命令名
```

### 技能

插件会自动在以下场景激活：
- 场景 1
- 场景 2

## 配置

如需配置，说明配置方法。

## 开发

### 项目结构

```
插件目录/
├── commands/
├── skills/
└── ...
```

### 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 作者

作者名
```

## 验证清单

**创建完成后，验证以下项目**：

### 必需项：
- [ ] `.claude-plugin/plugin.json` 存在且格式正确
- [ ] `name` 字段使用 kebab-case
- [ ] `README.md` 存在且包含安装说明
- [ ] 所有目录在正确位置（不在 `.claude-plugin/` 内）

### 可选项（如适用）：
- [ ] 命令文件在 `commands/` 目录
- [ ] 技能文件在 `skills/技能名/SKILL.md`
- [ ] 钩子配置在 `hooks/hooks.json`
- [ ] MCP 配置在 `.mcp.json`
- [ ] 脚本文件有执行权限（`chmod +x`）

### 测试：
- [ ] 使用 `claude --debug` 验证插件加载
- [ ] 检查命令是否出现在 `/` 命令列表
- [ ] 验证技能是否可被触发
- [ ] 测试钩子是否正常触发
- [ ] 确认 MCP 服务器正常启动

## 常见问题

### 插件未加载

**原因**：`plugin.json` 格式错误
**解决**：验证 JSON 语法

### 命令未出现

**原因**：目录结构错误
**解决**：确保 `commands/` 在根目录，不在 `.claude-plugin/` 内

### 钩子未触发

**原因**：脚本无执行权限
**解决**：运行 `chmod +x script.sh`

### MCP 服务器失败

**原因**：路径错误
**解决**：使用 `${CLAUDE_PLUGIN_ROOT}` 环境变量

## 最佳实践

### 命名规范
- 插件名：小写字母 + 连字符（`my-plugin`）
- 命令名：小写字母 + 连字符（`create-pr`）
- 技能名：小写字母 + 连字符（`test-driven-development`）

### 版本管理
- 遵循语义化版本（Semantic Versioning）
- 格式：`MAJOR.MINOR.PATCH`
  - MAJOR：不兼容的 API 更改
  - MINOR：向后兼容的功能新增
  - PATCH：向后兼容的问题修复

### 文档要求
- 每个命令必须有清晰的描述
- 每个技能必须有使用场景说明
- README 必须包含完整的安装和使用说明

### 代码质量
- 脚本文件应设置正确的执行权限
- 使用 `${CLAUDE_PLUGIN_ROOT}` 引用插件路径
- 避免硬编码路径

## 完整示例

参考示例插件：
- **git 插件**：Git 工作流自动化
  - 命令：`create-pr`, `draft-pr`, `review-pr`
  - 技能：`git:creating-pr`, `git:drafting-pr`, `git:reviewing-pr`

- **test 插件**：测试驱动开发
  - 技能：`test:test-driven-development`

- **plan 插件**：规划和设计
  - 技能：`plan:brainstorming`, `plan:writing-plans`, `plan:executing-plans`

## 下一步

插件创建完成后：

1. **本地测试**：使用 `claude --debug` 验证
2. **文档完善**：确保 README 和示例完整
3. **发布到 Marketplace**（可选）：创建插件市场
4. **维护更新**：根据用户反馈持续改进

## 环境变量

**`${CLAUDE_PLUGIN_ROOT}`**：
- 包含插件目录的绝对路径
- 在钩子、MCP 服务器和脚本中使用
- 确保路径无论安装位置如何都正确

**使用示例**：
```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh",
  "env": {
    "CONFIG_PATH": "${CLAUDE_PLUGIN_ROOT}/config.json"
  }
}
```

## 自定义路径（高级）

**在 plugin.json 中指定自定义路径**：

```json
{
  "commands": ["./custom/special.md", "./utilities/batch.md"],
  "agents": ["./custom-agents/reviewer.md"],
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json"
}
```

**重要**：
- 自定义路径补充默认目录，不会替换
- 所有路径必须相对于插件根目录
- 必须以 `./` 开头
- 可以指定单个路径或路径数组

## 调试技巧

**使用调试模式**：
```bash
claude --debug
```

**调试输出显示**：
- 哪些插件正在加载
- plugin.json 中的错误
- 命令、代理和钩子的注册
- MCP 服务器初始化

**常见调试场景**：
1. 插件未出现 → 检查 JSON 格式和目录结构
2. 命令未注册 → 检查 commands/ 目录位置
3. 钩子未触发 → 检查脚本权限和 hooks.json
4. MCP 失败 → 检查 `${CLAUDE_PLUGIN_ROOT}` 使用

## 插件组件总览

| 组件 | 默认位置 | 用途 |
|------|----------|------|
| **Manifest** | `.claude-plugin/plugin.json` | 必需的元数据文件 |
| **Commands** | `commands/` | Slash 命令的 Markdown 文件 |
| **Agents** | `agents/` | 子代理的 Markdown 文件 |
| **Skills** | `skills/` | 包含 SKILL.md 的 Agent Skills |
| **Hooks** | `hooks/hooks.json` | 钩子配置 |
| **MCP Servers** | `.mcp.json` | MCP 服务器定义 |
| **Scripts** | `scripts/` | 实用脚本和钩子脚本 |

## 最终检查

创建插件后，确保：

1. ✅ 目录结构符合规范
2. ✅ plugin.json 格式正确
3. ✅ README 包含完整的安装和使用说明
4. ✅ 所有必需文件存在
5. ✅ 使用 `claude --debug` 验证加载成功
6. ✅ 测试所有功能（命令、技能、钩子）
7. ✅ 脚本文件有正确的执行权限

完成！🎉
