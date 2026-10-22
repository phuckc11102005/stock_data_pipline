# 🌿 GitHub Workflow & Branching Strategy

## 1. Cấu trúc nhánh (Branch Strategy)

```
main          ←── Nhánh sản xuất (production-ready, luôn ổn định)
  │
  └── develop ←── Nhánh phát triển (tổng hợp tính năng đã review)
        │
        ├── feature/ING-03-yfinance-fetcher      (Role 1)
        ├── feature/PROC-07-signal-detector      (Role 2)
        ├── feature/ALERT-02-telegram-bot        (Role 3)
        ├── feature/OPS-01-docker-compose        (Role 4)
        └── fix/ING-05-null-validation-bug       (hotfix)
```

### Quy tắc đặt tên nhánh

| Loại | Pattern | Ví dụ |
|---|---|---|
| Tính năng mới | `feature/{TASK-ID}-{mo-ta-ngan}` | `feature/PROC-04-sma-indicator` |
| Sửa lỗi | `fix/{TASK-ID}-{mo-ta-loi}` | `fix/ING-07-retry-logic` |
| Cải thiện | `refactor/{TASK-ID}-{mo-ta}` | `refactor/PROC-10-optimize-duckdb` |
| Tài liệu | `docs/{mo-ta}` | `docs/update-architecture` |

---

## 2. Quy trình làm việc hàng ngày

```
1. Cập nhật develop mới nhất
   git checkout develop && git pull origin develop

2. Tạo nhánh tính năng mới
   git checkout -b feature/ING-03-yfinance-fetcher

3. Viết code + commit thường xuyên (nhỏ, rõ ràng)
   git add . && git commit -m "feat(ingestion): add yfinance fetcher with retry logic"

4. Đẩy nhánh lên remote
   git push origin feature/ING-03-yfinance-fetcher

5. Tạo Pull Request vào develop
   - Tiêu đề: [TASK-ID] Mô tả ngắn
   - Mô tả: Đã làm gì, cách test, screenshots nếu có

6. Chờ review & CI pass → Merge vào develop

7. Xoá nhánh sau khi merge
```

---

## 3. Commit Message Convention (Conventional Commits)

```
<type>(<scope>): <mô tả ngắn>

[thân message - tùy chọn]
[footer - tùy chọn]
```

**Các type phổ biến:**

| Type | Ý nghĩa | Ví dụ |
|---|---|---|
| `feat` | Tính năng mới | `feat(ingestion): add yfinance fetcher` |
| `fix` | Sửa lỗi | `fix(alerting): handle telegram rate limit` |
| `refactor` | Tái cấu trúc | `refactor(processing): switch from pandas to polars` |
| `test` | Thêm/sửa test | `test(ingestion): add validator unit tests` |
| `docs` | Tài liệu | `docs: update architecture diagram` |
| `chore` | Cấu hình, CI | `chore: add pre-commit hooks` |
| `perf` | Tối ưu hiệu năng | `perf(processing): optimize duckdb query` |

---

## 4. Pull Request Checklist

Trước khi tạo PR, tác giả phải tự kiểm tra:

```markdown
## PR Checklist
- [ ] Code chạy được trên máy local
- [ ] Đã viết / cập nhật unit tests
- [ ] Tất cả tests pass (pytest)
- [ ] Đã lint và format code (ruff, black)
- [ ] Không có hardcode credentials / API keys
- [ ] Đã cập nhật tài liệu liên quan (nếu thay đổi interface)
- [ ] PR nhỏ, tập trung vào 1 task (< 300 dòng thay đổi lý tưởng)
```

---

## 5. Code Review Guidelines

**Người review cần:**
- Review trong vòng **24 giờ** sau khi được assign
- Để lại comment cụ thể, không phán xét mà giải thích lý do
- Approve khi không còn blocking issues
- **Không merge PR của chính mình** (ngoại trừ Role 4 cho file cấu hình DevOps)

**Labels cho PR:**

| Label | Ý nghĩa |
|---|---|
| `ready-for-review` | PR đã hoàn chỉnh, cần review |
| `work-in-progress` | Draft PR, chưa cần review |
| `needs-changes` | Review yêu cầu sửa |
| `approved` | Đã được approve, chờ merge |
