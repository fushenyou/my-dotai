---
name: mysql-schema
description: 数据库结构分析技能 - 获取并缓存数据库结构信息，提供智能分析和建议
---

# Schema Analysis - 数据库结构分析

## 概述

此技能用于分析 MySQL 数据库结构，将表结构、索引、关系等信息缓存到模型记忆中，为后续的 SQL 生成和优化提供基础。

## 何时使用

**使用此技能当**：
- 需要了解数据库的完整结构
- 需要分析表之间的关系和依赖
- 需要为 SQL 生成提供上下文
- 需要评估数据库设计的合理性
- 需要导出数据库结构文档

**跳过此技能当**：
- ❌ 已经缓存了最新的数据库结构
- ❌ 只需要执行简单的查询，不需要了解结构
- ❌ 数据库结构没有发生变化

## 执行流程

### 1. 连接数据库并获取表列表

使用 MCP 工具连接到数据库：

```
使用 mysql MCP 服务器的 list_tables 工具获取所有表
```

### 2. 分析每个表的结构

对每个表执行：

```
使用 describe_table 工具获取表结构
包括：字段名、类型、是否为空、键、默认值、额外信息
```

### 3. 分析索引和关系

```
查询索引信息：SHOW INDEX FROM table_name
查询外键关系：
  SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
  WHERE TABLE_SCHEMA = DATABASE()
    AND REFERENCED_TABLE_NAME IS NOT NULL
```

### 4. 缓存到记忆

将结构信息整理成 JSON 格式并缓存：

```json
{
  "database": "database_name",
  "tables": {
    "table_name": {
      "columns": [...],
      "indexes": [...],
      "foreign_keys": [...],
      "primary_key": "...",
      "relationships": {
        "one_to_many": [...],
        "many_to_many": [...],
        "belongs_to": [...]
      }
    }
  },
  "summary": {
    "total_tables": 10,
    "total_columns": 85,
    "relationships": 12
  }
}
```

### 5. 支持输出参数

如果用户提供了 `--out` 参数：

```
将缓存的结构信息保存到指定目录
文件名格式：schema-{database_name}.json
```

## 最佳实践

1. **增量更新**：如果之前已经缓存过结构，只获取变更的部分
2. **性能优化**：对于大型数据库，考虑并行获取表结构
3. **错误处理**：某些表可能没有权限访问，需要优雅处理
4. **版本标记**：记录结构缓存的时间戳，便于判断是否需要更新

## 输出格式

向用户展示：

```markdown
✅ 数据库结构分析完成

**数据库**: {database_name}
**表数量**: {count}
**分析时间**: {timestamp}

**表列表**:
| 表名 | 字段数 | 索引数 | 关系数 |
|------|--------|--------|--------|
| ... | ... | ... | ... |

**结构摘要**:
- 主表：{list}
- 关联表：{list}
- 配置表：{list}

**已缓存到记忆中**，可用于后续的 SQL 生成和优化。
{if --out provided} 同时已保存到: {file_path}
```

## 注意事项

⚠️ 确保已配置 MySQL MCP 服务器连接
⚠️ 需要有数据库的读取权限
⚠️ 大型数据库可能需要较长时间
