# Design Review and Task Analysis

Review design specifications and analyze incomplete tasks for targeted implementation guidance.

**Important**: This command is for design review and alignment with users, NOT for implementation. Use `/dev:implement` for actual implementation work.

## Usage

```bash
/dev:design-review              # Automatically select first incomplete task
/dev:design-review [TASK-ID]    # Review specific task (e.g., ARCH-003, SIG-001)
```

## Process

1. **Task Selection and Analysis**
   - Read task checklist from `.tmp/tasks.md`
   - If no task specified in arguments: automatically select the first incomplete task
   - If task specified in arguments: validate and select the specified task
   - Load detailed task specifications from `.tmp/tasks/{task-id}.md`

2. **Design Document Analysis**
   - Read design overview from `.tmp/design.md`
   - Load feature-specific designs from `.tmp/design/` directory
   - Analyze architecture decisions for selected task
   - Cross-reference task requirements with design specifications

3. **Task-Specific Design Review**
   - Present selected task's design context and requirements
   - Analyze task dependencies and prerequisites
   - Highlight architectural decisions relevant to the task
   - Identify potential implementation challenges for the task

4. **User Alignment Session**
   - Present task-focused design overview in clear format
   - Explain task's role in overall system architecture
   - Request user confirmation on task priority and approach
   - Gather feedback on task-specific implementation strategy

5. **Gap Analysis**
   - Compare task requirements against design specifications
   - Identify any missing or unclear task-specific requirements
   - Flag potential implementation challenges for the selected task
   - Suggest task-specific design improvements or alternatives

6. **Consensus Building**
   - Discuss user concerns and suggestions
   - Revise design based on feedback
   - Confirm technical approach alignment
   - Get explicit approval before proceeding to implementation

## Review Structure

### Task Selection Presentation
- **Available Tasks**: List of incomplete tasks with priority indicators
- **Task Categories**: Architecture, feature implementation, integration phases
- **Dependencies**: Prerequisites and blocking relationships between tasks
- **Effort Estimation**: Complexity and time requirements for each task

### Task-Specific Design Review
- **Task Context**: Role within overall system architecture
- **Implementation Scope**: Specific deliverables and acceptance criteria
- **Technical Approach**: Algorithms, design patterns, and architectural decisions
- **Dependencies Analysis**: Required prerequisites and integration points
- **Risk Assessment**: Potential challenges and mitigation strategies

## User Interaction Format

### Task Selection Presentation (when no task specified)
```
## タスク選択: [プロジェクト名]

### 自動選択されたタスク
**ARCH-003**: 設定読み込みシステム作成

### その他利用可能な未完了タスク

#### 🏗️ アーキテクチャタスク
- [ ] ARCH-004: フックリクエストルーティング実装 (依存: ARCH-003)

#### 🔐 Git署名検証タスク  
- [ ] SIG-001: libgit2リポジトリラッパー実装 (優先度: 高)
- [ ] SIG-002: Git コマンドパーサー作成 (依存: SIG-001)

#### 📦 パッケージファイル保護タスク
- [ ] PKG-001: PreToolUseフック処理実装 (優先度: 中)

異なるタスクを選択したい場合は `/dev:design-review [TASK-ID]` を実行してください。
```

### Task Selection Presentation (when task specified)
```
## 指定されたタスク: [TASK-ID]

### タスク検証
✅ 指定されたタスクが見つかりました
✅ タスクは未完了です
✅ 依存関係が満たされています

このタスクで設計レビューを続行します。
```

### Task-Specific Design Review
```
## タスク設計レビュー: [TASK-ID]

### タスク概要
- **タスク**: [タスクの説明]
- **優先度**: [高/中/低]
- **推定工数**: [時間または複雑度]

### 設計文脈
[タスクがシステム全体でどの役割を果たすかの説明]

### 実装アプローチ
[技術的アプローチと設計決定の詳細]

### 依存関係
- **必須条件**: [完了必須のタスク]
- **ブロック対象**: [このタスクを待つタスク]

### 確認事項
1. このタスクの実装アプローチは適切ですか？
2. 依存関係や順序に問題はありませんか？
3. 追加で考慮すべき要件はありますか？
```

### Feedback Collection
- **Task Approval**: Explicit confirmation to proceed with selected task
- **Implementation Adjustments**: Specific changes to technical approach
- **Priority Re-evaluation**: Task selection or ordering preferences
- **Additional Context**: New requirements or clarifications for the task

## Integration Points

### Input Sources
- `.tmp/tasks.md` - Task checklist with completion status
- `.tmp/tasks/{task-id}.md` - Detailed task specifications
- `.tmp/design.md` - Main design document for context
- `.tmp/design/*.md` - Feature-specific designs related to the task

### Output Actions
- Present task selection options to user
- Provide detailed design review for selected task
- Update task priorities based on user feedback
- Prepare selected task for `/dev:implement` execution

## Quality Gates

### Pre-Review Checklist
- [ ] Task checklist (`.tmp/tasks.md`) exists and is accessible
- [ ] Incomplete tasks are identified and prioritized
- [ ] Task detail files exist for review candidates
- [ ] Related design documents are available for context

### Post-Review Validation
- [ ] User has selected a specific task for implementation
- [ ] Task requirements and approach are clearly understood
- [ ] Dependencies and prerequisites are identified
- [ ] Implementation approach is confirmed and approved

## Success Criteria

- **Task Selection**: User has chosen a specific task from available options
- **Context Understanding**: User comprehends the task's role in the overall system
- **Approach Alignment**: Technical implementation approach is agreed upon
- **Ready for Implementation**: Clear path forward with confirmed task and approach

## Next Steps

Upon successful task selection and design review:

```bash
/dev:implement [TASK-ID]
```

This will proceed directly to implement the selected and reviewed task using TDD methodology, with the design context already established through this review process.