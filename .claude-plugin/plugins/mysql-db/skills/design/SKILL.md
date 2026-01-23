---
name: mysql-design
description: 数据库架构设计技能 - 扮演 DB 架构师角色，设计合理、高性能、扩展性强的表结构
---

# Database Design - 数据库架构设计

## 概述

此技能扮演数据库架构师的角色，根据业务需求设计数据库表结构。重点关注规范化、性能优化、扩展性和可维护性。

## 何时使用

**使用此技能当**：
- 需要设计新的数据库表结构
- 需要重构现有数据库
- 需要评估数据库设计方案
- 需要优化数据库性能
- 需要设计数据仓库模型

**跳过此技能当**：
- ❌ 需求不明确
- ❌ 只需要简单的单表设计
- ❌ 只需要修改现有表的小问题

## 执行流程

### 1. 理解业务需求

详细询问和分析：

**核心实体**：
- 系统涉及哪些主要实体？
- 实体之间有什么关系？

**功能需求**：
- 需要支持哪些操作？
- 查询模式是什么？
- 数据量预估多大？

**非功能需求**：
- 性能要求（响应时间、并发量）
- 扩展性要求（未来增长）
- 数据一致性要求

### 2. 设计概念模型

使用 ER 图展示：

```
[用户] ||--o{ [订单] : 下单
[订单] ||--|{ [订单项] : 包含
[产品] ||--o{ [订单项] : 被订购
[分类] ||--o{ [产品] : 属于
```

### 3. 设计逻辑模型

遵循数据库设计原则：

**规范化**：
- 第一范式（1NF）：消除重复组
- 第二范式（2NF）：消除部分依赖
- 第三范式（3NF）：消除传递依赖
- BCNF：更严格的范式

**反规范化权衡**：
- 查询性能 > 规范化时考虑反规范化
- 添加冗余字段减少 JOIN
- 预计算聚合数据

### 4. 设计物理模型

创建建表语句：

```sql
-- 用户表
CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
  username VARCHAR(50) NOT NULL COMMENT '用户名',
  email VARCHAR(100) NOT NULL COMMENT '邮箱',
  password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态 1:正常 0:禁用',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  UNIQUE KEY uk_username (username),
  UNIQUE KEY uk_email (email),
  KEY idx_status (status),
  KEY idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 订单表
CREATE TABLE orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '订单ID',
  order_no VARCHAR(32) NOT NULL COMMENT '订单号',
  user_id BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
  total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
  status TINYINT NOT NULL DEFAULT 0 COMMENT '状态 0:待支付 1:已支付 2:已发货 3:已完成',
  remark TEXT COMMENT '备注',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  UNIQUE KEY uk_order_no (order_no),
  KEY idx_user_id (user_id),
  KEY idx_status (status),
  KEY idx_created_at (created_at),

  CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';
```

### 5. 性能优化设计

**索引策略**：

```sql
-- 主键索引
PRIMARY KEY (id)

-- 唯一索引
UNIQUE KEY uk_column (column)

-- 普通索引
KEY idx_column (column)

-- 联合索引（注意最左前缀）
KEY idx_col1_col2_col3 (col1, col2, col3)

-- 覆盖索引（包含查询所需的所有字段）
KEY idx_covering (user_id, status, created_at)
```

**分区策略**（大数据量时）：

```sql
-- 按时间分区
PARTITION BY RANGE (YEAR(created_at)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

### 6. 扩展性设计

**水平分表**：

```sql
-- 按用户 ID 分表
CREATE TABLE orders_0 LIKE orders;
CREATE TABLE orders_1 LIKE orders;

-- 分表规则：user_id % 2
```

**垂直分表**：

```sql
-- 热点字段（常用）
CREATE TABLE users_hot (
  id, username, email, status
);

-- 冷字段（不常用）
CREATE TABLE_users_cold (
  id, bio, preferences, settings
);
```

### 7. 数据完整性

**外键约束**：
```sql
CONSTRAINT fk_name FOREIGN KEY (column)
  REFERENCES table(id)
  ON DELETE CASCADE  -- 级联删除
  ON UPDATE RESTRICT -- 限制更新
```

**检查约束**（MySQL 8.0.16+）：
```sql
CONSTRAINT chk_age CHECK (age >= 0 AND age <= 150)
```

**触发器**：
```sql
CREATE TRIGGER trg_update_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
SET NEW.updated_at = CURRENT_TIMESTAMP;
```

## 设计原则

### 1. 命名规范

- 表名：小写，下划线分隔，复数形式（users, orders）
- 字段名：小写，下划线分隔（user_id, created_at）
- 索引名：
  - 主键：pk_表名
  - 唯一索引：uk_字段名
  - 普通索引：idx_字段名
  - 外键：fk_表名_字段名

### 2. 字段设计

| 数据类型 | 使用场景 |
|---------|---------|
| BIGINT | 主键、外键、大数值 |
| INT | 数量、状态码 |
| DECIMAL(10,2) | 金额、价格 |
| VARCHAR(n) | 短文本（< 255） |
| TEXT | 长文本 |
| TIMESTAMP | 时间戳 |
| TINYINT | 布尔值、小枚举 |

### 3. 性能优化

- ✅ 使用 NOT NULL 减少空值判断
- ✅ 固定长度字段优先
- ✅ 合理使用 VARCHAR 长度
- ✅ 避免使用 SELECT *
- ✅ 避免 TEXT 字段建索引
- ✅ 合理使用 ENUM（但注意扩展性）

### 4. 扩展性考虑

- ✅ 预留冗余字段
- ✅ 使用 JSON 字段存储扩展数据
- ✅ 设计时考虑分表分库
- ✅ 预留索引空间

## 输出格式

```markdown
✅ 数据库设计完成

**项目**: {project_name}
**设计时间**: {timestamp}

## 1. 实体关系图

```
{ER diagram}
```

## 2. 表结构设计

### 2.1 {table_name} - {description}

| 字段名 | 类型 | 空 | 默认 | 说明 |
|--------|------|-----|------|------|
| id | BIGINT | NO | AUTO_INCREMENT | 主键 |
| ... | ... | ... | ... | ... |

**索引**:
- PRIMARY KEY (id)
- UNIQUE KEY uk_xxx (xxx)
- KEY idx_xxx (xxx)

**关系**:
- FOREIGN KEY (user_id) REFERENCES users(id)

## 3. 设计说明

**规范化级别**: 第三范式（3NF）

**性能优化**:
- ✅ 为高频查询字段添加索引
- ✅ 使用覆盖索引优化常用查询
- ✅ 合理使用外键约束

**扩展性**:
- ✅ 预留扩展字段
- ✅ 使用 JSON 存储动态属性
- ✅ 考虑未来分表策略

## 4. DDL 语句

```sql
{complete DDL statements}
```

## 5. 使用建议

1. {suggestion_1}
2. {suggestion_2}
3. {suggestion_3}

## 6. 注意事项

⚠️ {warning_1}
⚠️ {warning_2}
```

## 常见场景设计

### 电商系统

- 用户（users）
- 商品（products）
- 分类（categories）
- 订单（orders）
- 订单项（order_items）
- 购物车（cart_items）

### 内容管理

- 文章（articles）
- 分类（categories）
- 标签（tags）
- 文章标签关联（article_tags）
- 评论（comments）

### 用户系统

- 用户（users）
- 角色（roles）
- 权限（permissions）
- 用户角色关联（user_roles）
- 角色权限关联（role_permissions）

## 注意事项

⚠️ 设计前充分了解业务需求
⚠️ 平衡规范化和性能
⚠️ 考虑数据迁移和兼容性
⚠️ 预留扩展空间
⚠️ 做好数据备份和恢复计划
