---
description: 扮演 DB 架构师角色，设计合理、高性能、扩展性强的数据库表结构
---

# /mysql-db:design - 数据库架构设计

当用户执行此命令时，使用 `mysql-design` 技能来设计数据库表结构。

## 执行步骤

1. **理解业务需求**
   - 详细询问业务场景
   - 识别核心实体和关系
   - 明确功能和非功能需求
   - 了解数据量预估

2. **设计概念模型**
   - 绘制 ER 图
   - 定义实体和属性
   - 确定关系类型（1:1, 1:N, N:M）

3. **设计逻辑模型**
   - 应用数据库规范化原则
   - 设计表结构
   - 定义主键和外键
   - 处理多对多关系

4. **设计物理模型**
   - 编写完整的 DDL 语句
   - 设计索引策略
   - 选择合适的数据类型
   - 添加约束和默认值

5. **性能优化**
   - 分析查询模式
   - 设计覆盖索引
   - 考虑分区策略
   - 评估反规范化需求

6. **扩展性设计**
   - 考虑未来增长
   - 设计分表分库方案
   - 预留扩展字段
   - 设计迁移方案

## 用户输入

通过 `$ARGUMENTS` 获取用户输入：
- 需求描述（自然语言）
- 可选参数：
  - `--tables <n>`: 预估表数量
  - `--records <n>`: 预估数据量
  - `--qps <n>`: 预估 QPS
  - `--out <path>`: 输出 DDL 文件路径

## 示例

```bash
# 电商系统设计
/mysql-db:design 设计一个电商系统的数据库，包括用户、商品、订单、分类等功能

# 内容管理系统
/mysql-db:design 设计一个 CMS 系统，支持文章、分类、标签、评论

# 社交平台
/mysql-db:design 设计一个社交平台，包含用户动态、好友关系、消息、点赞

# 带参数的设计
/mysql-db:design 设计一个在线教育平台 --tables 20 --records 100000 --qps 1000 --out ./schema.sql
```

## 输出格式

```
✅ 数据库设计完成

**项目**: 电商系统
**设计时间**: 2024-01-23 10:30:00

## 1. 需求分析

**核心功能**:
- 用户注册、登录、个人信息管理
- 商品浏览、搜索、分类
- 购物车、下单、支付
- 订单管理和物流跟踪

**非功能需求**:
- 数据量: 100万+ 用户, 1000万+ 订单
- QPS: 峰值 5000+
- 响应时间: < 200ms
- 可用性: 99.9%

## 2. 实体关系图

```
┌─────────┐
│ 用户    │
└─────────┘
    │
    │ 1:N
    ↓
┌─────────┐       ┌─────────┐
│ 订单    │──────→│ 订单项  │
└─────────┘  N:N  └─────────┘
    │                ↑
    │ N:1            │ N:1
    ↓                │
┌─────────┐       ┌─────────┐
│ 地址    │       │ 商品    │
└─────────┘       └─────────┘
                      ↑
                      │ N:1
                      ↓
                  ┌─────────┐
                  │ 分类    │
                  └─────────┘
```

**关系说明**:
- 用户 1:N 订单
- 订单 1:N 订单项
- 商品 N:M 订单项
- 分类 1:N 商品
- 用户 1:N 地址

## 3. 表结构设计

### 3.1 users - 用户表

| 字段名 | 类型 | 空 | 默认 | 说明 |
|--------|------|-----|------|------|
| id | BIGINT | NO | AUTO_INCREMENT | 用户ID |
| username | VARCHAR(50) | NO | | 用户名 |
| email | VARCHAR(100) | NO | | 邮箱 |
| password_hash | VARCHAR(255) | NO | | 密码哈希 |
| phone | VARCHAR(20) | YES | | 手机号 |
| avatar | VARCHAR(255) | YES | | 头像 |
| status | TINYINT | NO | 1 | 状态 1:正常 0:禁用 |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | 更新时间 |

**索引**:
- PRIMARY KEY (id)
- UNIQUE KEY uk_username (username)
- UNIQUE KEY uk_email (email)
- KEY idx_phone (phone)
- KEY idx_status (status)

**关系**:
- 到 orders: 1:N
- 到 addresses: 1:N

### 3.2 orders - 订单表

| 字段名 | 类型 | 空 | 默认 | 说明 |
|--------|------|-----|------|------|
| id | BIGINT | NO | AUTO_INCREMENT | 订单ID |
| order_no | VARCHAR(32) | NO | | 订单号 |
| user_id | BIGINT | NO | | 用户ID |
| total_amount | DECIMAL(10,2) | NO | | 总金额 |
| status | TINYINT | NO | 0 | 状态 0:待支付 1:已支付 |
| pay_time | TIMESTAMP | YES | | 支付时间 |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | 更新时间 |

**索引**:
- PRIMARY KEY (id)
- UNIQUE KEY uk_order_no (order_no)
- KEY idx_user_id (user_id)
- KEY idx_status (status)
- KEY idx_created_at (created_at)
- KEY idx_user_status (user_id, status, created_at)

**关系**:
- FOREIGN KEY (user_id) REFERENCES users(id)

[其他表结构...]

## 4. 设计说明

**规范化**: 第三范式（3NF）

**性能优化**:
✅ 为高频查询字段添加索引
✅ 使用覆盖索引优化常用查询
✅ 订单表按 user_id, status, created_at 建立联合索引
✅ 订单号使用唯一索引防止重复
✅ 合理使用外键约束保证数据一致性

**扩展性**:
✅ 预留扩展字段（JSON 类型）
✅ 订单表考虑按时间分区
✅ 设计分表策略（按 user_id 分表）
✅ 商品表使用 JSON 存储扩展属性

**数据量预估**:
- users: 100万+ (按 ID 范围分表)
- orders: 1000万+ (按用户 ID 哈希分表)
- products: 10万+ (单表)
- order_items: 3000万+ (按订单 ID 分表)

## 5. DDL 语句

完整的建表语句已生成，包含：
- 8 张核心表
- 所有索引和约束
- 外键关系
- 表注释和字段注释

```sql
-- [完整的 DDL 语句]
```

📄 已保存到: ./schema/ecommerce-20240123.sql

## 6. 使用建议

1. **分步实施**:
   - 先创建核心表（users, products, orders）
   - 再创建关联表（order_items, categories）
   - 最后创建扩展表（addresses, carts）

2. **索引优化**:
   - 先创建基础索引
   - 根据查询模式调整索引
   - 定期分析慢查询日志

3. **数据迁移**:
   - 准备测试数据
   - 验证数据一致性
   - 制定回滚方案

4. **监控告警**:
   - 监控表大小和增长速度
   - 监控慢查询
   - 设置索引使用率告警

## 7. 注意事项

⚠️ 订单表数据量大，建议提前规划分表策略
⚠️ 商品价格需考虑精度，使用 DECIMAL(10,2)
⚠️ 用户密码必须加密存储（bcrypt/argon2）
⚠️ 订单号生成需考虑并发和唯一性
⚠️ 外键约束可能影响性能，根据实际情况调整
```

## 设计原则

### 1. 规范化与性能平衡
- 核心业务表遵循 3NF
- 报表和分析表适当反规范化
- 热点字段冗余减少 JOIN

### 2. 命名规范
- 表名: 小写，下划线分隔，复数形式
- 字段名: 小写，下划线分隔
- 索引名: pk_/uk_/idx_/fk_ 前缀
- 布尔字段: is_, has_ 前缀

### 3. 数据类型选择
- 主键: BIGINT (支持大容量)
- 金额: DECIMAL(10,2)
- 时间: TIMESTAMP (自动更新)
- 枚举: TINYINT (不用 ENUM)
- 文本: VARCHAR(长度适中)

### 4. 索引策略
- 主键索引: 所有表
- 唯一索引: 业务唯一字段
- 普通索引: WHERE/JOIN/ORDER BY 字段
- 联合索引: 注意最左前缀

## 常见场景设计模板

### 用户系统
```
users, roles, permissions, user_roles, role_permissions
```

### 内容管理
```
articles, categories, tags, article_tags, comments
```

### 电商系统
```
users, products, categories, orders, order_items, carts, addresses
```

### 订单系统
```
orders, order_items, order_status_log, payments, refunds
```

### 消息系统
```
messages, conversations, conversation_participants, message_reads
```

## 重要提示

- ⚠️ 设计前充分了解业务需求
- ⚠️ 平衡规范化和性能
- ⚠️ 考虑数据迁移和兼容性
- ⚠️ 预留扩展空间
- ⚠️ 做好数据备份和恢复计划
- ⚠️ 生产环境使用前充分测试
- ⚠️ 考虑分表分库策略
