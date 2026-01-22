# my-dotai

> Claude Code 插件集合（Marketplace）- 简化开发工作流

这是一个为 Claude Code 定制的插件集合（Marketplace），提供 Git 自动提交、Figma 设计稿转代码等实用功能。

## 📦 包含的插件

### 1. Git 插件

自动 Git 提交工具，一键生成语义化提交信息。

**功能**：
- 自动暂存所有修改
- 智能分析修改内容
- 生成符合 Conventional Commits 规范的提交信息
- 一键完成提交

**使用**：
```bash
/git:commit
```

**文档**：[Git 插件文档](./.claude-plugin/plugins/git/README.md)

### 2. Figma 插件

Figma 设计稿转代码插件，通过 figma-developer-mcp 高度还原设计细节。

**功能**：
- 获取 Figma 设计稿详细信息
- 智能分析布局、样式、组件
- 生成 React/Vue/HTML 代码
- 支持 Tailwind CSS、CSS Modules、Styled Components
- 自动 MCP 配置

**使用**：
```bash
/figma:to-code
```

**文档**：[Figma 插件文档](./.claude-plugin/plugins/figma/README.md)

## 🚀 安装 Marketplace

### 方式一：通过 Claude Code UI（推荐）

1. 打开 Claude Code
2. 进入 **Settings** → **Plugins**
3. 点击 **"Add Marketplace"**
4. 输入：`github.com/fushenyou/my-dotai`
5. 点击 **"Add"**
6. 选择要安装的插件（Git 或 Figma）

### 方式二：手动配置

编辑 `~/.claude/extra_marketplaces.json`（如果不存在则创建）：

```json
{
  "my-dotai": {
    "source": {
      "source": "github",
      "repo": "fushenyou/my-dotai"
    }
  }
}
```

然后重启 Claude Code，在 **Settings** → **Plugins** 中可以看到并安装插件。

## 🔧 配置插件

### Git 插件

无需额外配置，安装后可直接使用。

### Figma 插件

安装后需要配置 Figma Access Token：

**macOS/Linux**：
```bash
cd ~/.claude/plugins/marketplaces/my-dotai/.claude-plugin/plugins/figma
bash install.sh figd_your_token_here
```

**Windows**：
```powershell
cd ~/.claude\plugins\marketplaces\my-dotai\.claude-plugin\plugins\figma
powershell -ExecutionPolicy Bypass -File install.ps1 -FigmaApiKey "figd_your_token_here"
```

**配置说明**：
- Token 会被添加到 `~/.claude/settings.json`
- MCP 服务器会自动读取环境变量
- 重启 Claude Code 后生效

详见：[Figma 快速开始](./.claude-plugin/plugins/figma/QUICKSTART.md)

## 📖 使用指南

### Git 自动提交

```bash
# 在 Claude Code 中执行
/git:commit

# 插件会自动：
# 1. git add .
# 2. 分析修改内容
# 3. 生成提交信息
# 4. 完成提交
```

### Figma 设计稿转代码

```bash
# 在 Claude Code 中执行
/figma:to-code

# 然后提供 Figma URL
请将这个设计稿转换为 React + Tailwind 代码：
https://www.figma.com/file/xxxxx
```

## 🏗️ 项目结构

```
my-dotai/
├── .claude-plugin/
│   ├── marketplace.json        # Marketplace 配置
│   └── plugins/
│       ├── git/                # Git 插件
│       │   ├── .claude-plugin/
│       │   │   └── plugin.json
│       │   ├── commands/
│       │   │   └── commit.md
│       │   └── README.md
│       └── figma/              # Figma 插件
│           ├── .claude-plugin/
│           │   └── plugin.json
│           ├── .mcp.json       # MCP 服务器配置
│           ├── commands/
│           │   └── to-code.md
│           ├── install.sh      # 配置脚本
│           ├── install.ps1
│           ├── README.md
│           ├── QUICKSTART.md
│           └── ARCHITECTURE.md
└── registry/                   # 注册表文件
    └── index.json
```

## 🎯 Marketplace 规范

这个仓库遵循 [Claude Code Marketplace 标准](https://claude.ai/docs/marketplace)：

### 必需文件

- `.claude-plugin/marketplace.json` - Marketplace 配置
- `.claude-plugin/plugins/xxx/.claude-plugin/plugin.json` - 插件元数据
- `.claude-plugin/plugins/xxx/commands/*.md` - 插件命令

### 可选文件

- `.mcp.json` - MCP 服务器配置
- `install.sh` / `install.ps1` - 配置脚本
- `README.md` - 插件文档

## 🛠️ 开发

### 添加新插件

1. 创建插件目录：
```bash
mkdir -p .claude-plugin/plugins/your-plugin/{.claude-plugin,commands}
```

2. 添加插件配置 `.claude-plugin/plugin.json`：
```json
{
  "name": "your-plugin",
  "description": "插件描述",
  "version": "0.1.0",
  "author": {
    "name": "your-name",
    "email": "your-email@example.com"
  }
}
```

3. 添加插件命令 `commands/your-command.md`：
```markdown
---
description: 命令描述
---

命令的详细指令...
```

4. 更新 `.claude-plugin/marketplace.json`：
```json
{
  "plugins": [
    {
      "name": "your-plugin",
      "source": "./.claude-plugin/plugins/your-plugin",
      "description": "插件描述"
    }
  ]
}
```

### 测试插件

```bash
# 克隆你的 marketplace 仓库到本地
cd ~/.claude/plugins/marketplaces
git clone https://github.com/fushenyou/my-dotai.git

# 重启 Claude Code
# 插件会自动加载
```

## 🤝 贡献

欢迎贡献！你可以：

- 报告 Bug
- 提出新功能建议
- 提交 Pull Request
- 改进文档

### 贡献流程

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat: add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

## 📚 相关资源

- [Claude Code 官方文档](https://claude.ai/docs)
- [dotai Marketplace](https://github.com/udecode/dotai) - 灵感来源
- [MCP 协议规范](https://modelcontextprotocol.io/)

## 📝 许可证

MIT License

## 👤 作者

Created by [fushenyou](https://github.com/fushenyou)

## 🙏 致谢

- [dotai](https://github.com/udecode/dotai) - 项目结构和最佳实践参考
- [Claude Code Team](https://claude.ai) - 优秀的开发工具
