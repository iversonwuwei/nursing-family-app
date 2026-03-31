# nursing-family-app

养老护理家属端 App + AI 体验工程，基于 Flutter 3 与 GetX 实现。

## 当前范围

- 家属首页：老人状态、今日护理、快捷入口、AI 今日摘要
- 健康页：血压、心率、睡眠、步数趋势与家属友好解释
- 护理页：护理记录与 AI 护理说明
- 探视页：预约探视、视频沟通、探视记录、AI 探视建议
- 我的页：消息、账单、报警历史、服务反馈入口
- 次级页面：消息中心、账单中心、护理反馈、远程视频、报警历史、AI 今日摘要、AI 探视助手

## 设计来源

本工程根据 nursing-documents 中的以下文档落地：

- docs/platform/PRODUCT_DESIGN.md
- docs/platform/MODULE_PAGE_MAPPING.md
- docs/platform/AI_AGENT_ARCHITECTURE.md
- docs/platform/PLATFORM_ARCHITECTURE.md
- docs/platform/IMPLEMENTATION_BLUEPRINT.md

## 架构约束

- 状态管理：GetX
- 页面基类：所有页面均使用 GetView
- 页面实现：以小组件拆分区块，避免单文件巨型 build 方法
- 当前数据源：MockFamilyService，便于后续替换为真实 API / BFF

## 本地运行

```bash
flutter pub get
flutter run
```

## 质量门禁

```bash
flutter analyze
flutter test
```

## 工程设计说明

本地 docs Markdown 已迁移到 nursing-documents 统一管理，工程设计说明见 ../nursing-documents/docs/ui/family-delivery/app-design.md

已完成的页面级交付说明索引见 ../nursing-documents/docs/ui/family-delivery/index.md

## Harness 交付模板

后续页面、路由、交互与数据流改动，默认先按 ../nursing-documents/docs/ui/family-delivery/frontend-delivery-template.md 补齐范围、用户影响、数据来源、UI 状态、健康信号、验证门禁和回滚路径，再进入实现。
