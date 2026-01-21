# Figma Plugin - 快速开始

## 🚀 5 分钟快速配置

### 步骤 1: 获取 Figma Access Token

1. 访问 https://www.figma.com/developers/api#access-tokens
2. 点击 "Create new access token"
3. 复制生成的 token
   - **标准格式**：`figd_xxxx...`（Personal Access Token）
   - 其他格式也可以使用，脚本会智能识别

### 步骤 2: 安装插件

从 GitHub 克隆仓库：

```bash
git clone https://github.com/fushenyou/my-dotai.git
cd my-dotai
```

### 步骤 3: 配置 MCP

**macOS/Linux**：
```bash
bash .claude-plugin/plugins/figma/install.sh figd_your_token_here
```

**Windows**：
```powershell
powershell -ExecutionPolicy Bypass -File .claude-plugin\plugins\figma\install.ps1 -FigmaApiKey "figd_your_token_here"
```

### 步骤 4: 重启 Claude Code

关闭并重新打开 Claude Code。

### 步骤 5: 开始使用

```bash
/figma
```

然后提供你的 Figma 设计稿 URL。

## 📋 配置验证

### 检查配置文件

```bash
cat ~/.claude/settings.json
```

应该包含：
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

### 测试 MCP 连接

在 Claude Code 中运行：
```
使用 Figma MCP 获取设计稿信息
```

如果配置成功，Claude 会访问 Figma API。

## 🎯 常见问题

### Q: Token 在哪里保存？
A: 保存在 `~/.claude/settings.json` 的 `env.FIGMA_ACCESS_TOKEN` 字段中。

### Q: 如何更新 Token？
A: 重新运行配置脚本即可：
```bash
bash .claude-plugin/plugins/figma/install.sh new_token_here
```

### Q: 必须是 `figd_` 开头的 Token 吗？
A: 不是必须的。虽然标准的 Figma Personal Access Token 以 `figd_` 开头，但脚本也接受其他格式的有效 Token（长度至少 20 字符）。如果使用非标准格式，脚本会给出友好提示。

### Q: 脚本提示 "jq: command not found"？
A: 不影响使用，可以手动编辑 `~/.claude/settings.json`。

### Q: Windows PowerShell 执行策略错误？
A: 使用：
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

## 📞 需要帮助？

- 查看 [完整文档](./README.md)
- 提交 Issue: https://github.com/fushenyou/my-dotai/issues

## 🔐 安全提示

- 不要将 Figma Access Token 提交到 Git 仓库
- 定期轮换你的 Access Token
- 在 Figma 设置中可以随时撤销 Token

## 📝 配置文件说明

### .mcp.json
MCP 服务器配置，定义了如何启动 `figma-developer-mcp`。

### install.sh / install.ps1
自动配置脚本，会：
1. 验证 API Key 格式
2. 更新 `~/.claude/settings.json`
3. 启用 Figma 插件

### plugin.json
插件元数据，包含插件名称、版本等信息。
