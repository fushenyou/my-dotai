---
description: 获取数据库结构并缓存到模型记忆，支持 --out 参数保存到文件
---

# /mysql-db:schema - 获取数据库结构

当用户执行此命令时，使用 `mysql-schema` 技能来获取和分析数据库结构。

## 执行步骤

1. **检查 MCP 连接**
   - 确认 MySQL MCP 服务器已配置
   - 验证数据库连接参数

2. **获取数据库结构**
   - 使用 `list_tables` 工具获取所有表
   - 使用 `describe_table` 工具获取每个表的结构
   - 查询索引信息：`SHOW INDEX FROM table_name`
   - 查询外键关系：从 `INFORMATION_SCHEMA.KEY_COLUMN_USAGE` 获取

3. **分析表关系**
   - 识别主键和外键
   - 确定一对一、一对多、多对多关系
   - 分析依赖关系

4. **缓存到记忆**
   - 将完整的结构信息整理成 JSON 格式
   - 缓存到模型的上下文记忆中
   - 记录时间戳和数据库版本

5. **处理输出参数**
   - 如果用户提供了 `--out` 参数
   - 将结构信息保存到指定目录
   - 文件名格式：`schema-{database_name}-{timestamp}.json`

## 用户输入

通过 `$ARGUMENTS` 获取用户输入：
- `--out <path>`: 可选，指定保存路径

## 示例

```bash
# 基本使用
/mysql-db:schema

# 保存到文件
/mysql-db:schema --out ./db-schema
```

## 输出格式

向用户展示：

```
✅ 数据库结构分析完成

**数据库**: my_database
**表数量**: 15
**字段总数**: 127
**关系总数**: 12
**分析时间**: 2024-01-23 10:30:00

**主要表**:
- users (用户表) - 12 字段
- orders (订单表) - 15 字段
- products (商品表) - 18 字段
...

**关系图**:
users ||--o{ orders : 下单
orders ||--|{ order_items : 包含
products ||--o{ order_items : 被订购

✅ 结构已缓存到记忆中
📁 已保存到: ./db-schema/schema-my-db-20240123.json
```

## 重要提示

- 必须先配置 MySQL MCP 服务器
- 需要数据库的读取权限
- 大型数据库可能需要较长时间
- 缓存的结构将用于后续的 SQL 生成和优化
