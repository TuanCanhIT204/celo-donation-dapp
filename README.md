Celo Donation DApp – Transparent Charity Platform
Thành viên nhóm thực hiện :
Đặng Tuấn Cảnh
Bùi Lê Minh


A, Giới thiệu
Celo Donation DApp là ứng dụng phi tập trung (DApp) cho phép mọi người tạo chiến dịch gây quỹ, quyên góp CELO token, và rút tiền minh bạch trực tiếp trên blockchain Celo.
Toàn bộ giao dịch, người quyên góp và số tiền đều được ghi lại công khai trên mạng thử nghiệm Celo Sepolia Testnet.

⚙️ Tính năng chính
✅ Tạo chiến dịch (Create Campaign) – người dùng tạo chiến dịch mới với tiêu đề, mô tả, người thụ hưởng và mục tiêu (CELO).
✅ Quyên góp (Donate) – gửi CELO trực tiếp đến chiến dịch bằng ví MetaMask.
✅ Rút tiền (Withdraw) – chỉ người thụ hưởng (beneficiary) có thể rút tiền đã được quyên góp.
✅ Đóng chiến dịch (Close) – chỉ người tạo (creator) được phép đóng chiến dịch.
✅ Xem minh bạch (Transparency) – mọi người có thể xem danh sách người quyên góp và tổng tiền đã huy động.

B,Cấu trúc thư mục và vai trò :
celo-donation-dapp/
├─ index.html                 # Giao diện web: kết nối ví, gọi contract
├─ contracts/
│  └─ DonationPlatform.sol    # Hợp đồng thông minh (logic on-chain)
├─ artifacts/
│  └─ DonationPlatform.json   # ABI (để frontend hiểu hàm/event)
└─ README.md                  # Tài liệu này

C,Smart Contract: DonationPlatform1.sol
1.Struct & storage

struct Campaign { address creator; address beneficiary; string title; string description; uint256 goal; uint256 raised; bool active; }
uint256 public campaignCount;
mapping(uint256 => Campaign) public campaigns;
mapping(uint256 => mapping(address => uint256)) public donatedOf;
mapping(uint256 => address[]) private donors;

Campaign: thông tin 1 chiến dịch (mục tiêu, đã huy động, trạng thái mở/đóng).
campaignCount: đếm số chiến dịch (ID mới = ++campaignCount).
campaigns[id]: lưu chiến dịch theo ID.
donatedOf[id][donor]: tổng tiền donor đã donate vào campaign id (để hiển thị minh bạch).
donors[id]: danh sách địa chỉ đã donate (phục vụ UI).

2.Sự kiện (events)

event CampaignCreated(uint256 id, address creator, address beneficiary, string title, uint256 goal);
event DonationReceived(uint256 id, address donor, uint256 amount, uint256 newRaised);
event Withdrawal(uint256 id, address beneficiary, uint256 amount);
event CampaignClosed(uint256 id);

Được phát ra mỗi khi create/donate/withdraw/close → UI có thể đọc log hoặc xem explorer để chứng minh minh bạch.

3.Hàm chính

createCampaign(_beneficiary,_title,_description,_goal)
Tạo chiến dịch mới, goal tính bằng wei. Phát CampaignCreated.

donate(id) payable
Yêu cầu msg.value > 0, campaign.active == true. Cộng dồn raised, lưu dấu vết donatedOf và push donor mới nếu lần đầu. Phát DonationReceived.

withdraw(id, amount)
Chỉ beneficiary được rút; amount > 0 và ≤ raised. Gửi CELO cho beneficiary, trừ raised. Phát Withdrawal.

closeCampaign(id)
Chỉ creator; đặt active=false. Phát CampaignClosed.

getDonors(id)
Trả danh sách donor (địa chỉ), dùng cho UI minh bạch.


