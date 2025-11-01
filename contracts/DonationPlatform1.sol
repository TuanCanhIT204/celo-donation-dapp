// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Donation Platform (Transparent charity) – Celo
 * Tính năng chính:
 * - Tạo chiến dịch (campaign) minh bạch: tên, mô tả, beneficiary, goal.
 * - Donate và log sự kiện; tổng số tiền raised theo campaign & theo donor.
 * - Beneficiary rút tiền theo số đã nhận (không bị kẹt).
 * - Hủy campaign (optional) để đóng nhận donate mới.
 * - Public getters để truy xuất minh bạch.
 */
contract DonationPlatform {
    struct Campaign {
        address creator;
        address beneficiary;
        string title;
        string description;
        uint256 goal;        // mục tiêu (wei)
        uint256 raised;      // đã nhận (wei)
        bool active;         // còn nhận donate?
    }

    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public donatedOf; // donatedOf[campaignId][donor]
    mapping(uint256 => address[]) private donors; // danh sách donor cho campaign (phục vụ thống kê)

    event CampaignCreated(uint256 indexed id, address indexed creator, address indexed beneficiary, string title, uint256 goal);
    event DonationReceived(uint256 indexed id, address indexed donor, uint256 amount, uint256 newRaised);
    event Withdrawal(uint256 indexed id, address indexed beneficiary, uint256 amount);
    event CampaignClosed(uint256 indexed id);

    error NotCreator();
    error NotBeneficiary();
    error InactiveCampaign();
    error ZeroAmount();
    error NothingToWithdraw();

    // Tạo campaign
    function createCampaign(
        address _beneficiary,
        string calldata _title,
        string calldata _description,
        uint256 _goal
    ) external returns (uint256 id) {
        require(_beneficiary != address(0), "beneficiary required");

        id = ++campaignCount;
        campaigns[id] = Campaign({
            creator: msg.sender,
            beneficiary: _beneficiary,
            title: _title,
            description: _description,
            goal: _goal,
            raised: 0,
            active: true
        });

        emit CampaignCreated(id, msg.sender, _beneficiary, _title, _goal);
    }

    // Donate vào 1 campaign
    function donate(uint256 id) external payable {
        Campaign storage c = campaigns[id];
        if (!c.active) revert InactiveCampaign();
        if (msg.value == 0) revert ZeroAmount();

        if (donatedOf[id][msg.sender] == 0) {
            donors[id].push(msg.sender);
        }
        donatedOf[id][msg.sender] += msg.value;
        c.raised += msg.value;

        emit DonationReceived(id, msg.sender, msg.value, c.raised);
    }

    // Beneficiary rút 1 phần hoặc toàn bộ số tiền đã nhận
    function withdraw(uint256 id, uint256 amount) external {
        Campaign storage c = campaigns[id];
        if (msg.sender != c.beneficiary) revert NotBeneficiary();
        if (amount == 0 || amount > c.raised) revert NothingToWithdraw();

        c.raised -= amount;
        (bool ok, ) = payable(c.beneficiary).call{value: amount}("");
        require(ok, "transfer failed");

        emit Withdrawal(id, c.beneficiary, amount);
    }

    // Creator đóng campaign (không nhận donate mới)
    function closeCampaign(uint256 id) external {
        Campaign storage c = campaigns[id];
        if (msg.sender != c.creator) revert NotCreator();
        c.active = false;
        emit CampaignClosed(id);
    }

    // Lấy danh sách donors (để hiển thị minh bạch)
    function getDonors(uint256 id) external view returns (address[] memory) {
        return donors[id];
    }
}