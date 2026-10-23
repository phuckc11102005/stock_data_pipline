## Mô tả

<!-- Tóm tắt ngắn gọn những gì PR này thay đổi và tại sao -->

---

## ⚠️ Liên kết Issue (BẮT BUỘC)

<!-- Điền số issue — GitHub sẽ tự CLOSE issue khi PR được merge vào develop/main -->
Closes #

---

## Loại thay đổi

- [ ] `feat` – Tính năng mới
- [ ] `fix` – Sửa lỗi
- [ ] `refactor` – Tái cấu trúc code
- [ ] `test` – Thêm / cập nhật tests
- [ ] `docs` – Cập nhật tài liệu
- [ ] `chore` – Cấu hình, CI/CD
- [ ] `perf` – Tối ưu hiệu năng

---

## PR Checklist

> Tác giả phải tự kiểm tra trước khi tạo PR — theo [docs/05-github-workflow.md](docs/05-github-workflow.md)

- [ ] Code chạy được trên máy local
- [ ] Đã viết / cập nhật unit tests
- [ ] Tất cả tests pass (`pytest`)
- [ ] Đã lint và format code (`ruff`, `black`)
- [ ] **Không có hardcode credentials / API keys**
- [ ] Đã cập nhật tài liệu liên quan (nếu thay đổi interface)
- [ ] PR nhỏ, tập trung vào 1 task (< 300 dòng thay đổi lý tưởng)
- [ ] **Đã điền `Closes #<số>` ở phần Liên kết Issue phía trên**

---

## Cách test

<!-- Mô tả cách reviewer có thể tự test thay đổi này -->

```bash
# ví dụ:
pytest tests/ingestion/test_validators.py -v
```

---

## Screenshots / Output (nếu có)

<!-- Paste output, screenshot, hoặc log nếu cần minh chứng -->
