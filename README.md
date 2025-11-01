Celo Donation DApp – Transparent Charity Platform
🧩 Giới thiệu

Celo Donation DApp là ứng dụng phi tập trung (DApp) cho phép mọi người tạo chiến dịch gây quỹ, quyên góp CELO token, và rút tiền minh bạch trực tiếp trên blockchain Celo.
Toàn bộ giao dịch, người quyên góp và số tiền đều được ghi lại công khai trên mạng thử nghiệm Celo Sepolia Testnet.

⚙️ Tính năng chính

✅ Tạo chiến dịch (Create Campaign) – người dùng tạo chiến dịch mới với tiêu đề, mô tả, người thụ hưởng và mục tiêu (CELO).
✅ Quyên góp (Donate) – gửi CELO trực tiếp đến chiến dịch bằng ví MetaMask.
✅ Rút tiền (Withdraw) – chỉ người thụ hưởng (beneficiary) có thể rút tiền đã được quyên góp.
✅ Đóng chiến dịch (Close) – chỉ người tạo (creator) được phép đóng chiến dịch.
✅ Xem minh bạch (Transparency) – mọi người có thể xem danh sách người quyên góp và tổng tiền đã huy động.

.

🧠 Kiến trúc DApp
frontend/        ← index.html (DApp giao diện người dùng)
contracts/       ← DonationPlatform.sol (smart contract)
artifacts/       ← DonationPlatform.json (ABI & bytecode)

🚀 Hướng dẫn chạy DApp cục bộ
1️⃣ Yêu cầu

Cài MetaMask (phiên bản mới nhất).

Chọn mạng Celo Sepolia Testnet.

Có một ít CELO test token (có thể claim từ faucet).

Cài VS Code + Live Server để chạy web cục bộ.

2️⃣ Chạy giao diện web

Mở thư mục dự án trong VS Code.

Click phải vào index.html → chọn Open with Live Server.

Trình duyệt sẽ mở http://localhost:5500/index.html.

Kết nối ví bằng Connect Wallet.

Dán địa chỉ contract bạn đã deploy → Use Contract.
