
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GreenBountyDAO {
    struct Bounty {
        string description;
        string evidenceIPFS;
        address submitter;
        bool approved;
    }

    address public owner;
    Bounty[] public bounties;

    event BountySubmitted(uint bountyId, address indexed submitter);
    event BountyApproved(uint bountyId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the DAO owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function submitBounty(string memory _description, string memory _evidenceIPFS) public {
        Bounty memory newBounty = Bounty({
            description: _description,
            evidenceIPFS: _evidenceIPFS,
            submitter: msg.sender,
            approved: false
        });

        bounties.push(newBounty);
        emit BountySubmitted(bounties.length - 1, msg.sender);
    }

    function approveBounty(uint _bountyId) public onlyOwner {
        require(_bountyId < bounties.length, "Invalid bounty ID");
        bounties[_bountyId].approved = true;
        emit BountyApproved(_bountyId);
    }

    function getBounty(uint _bountyId) public view returns (string memory, string memory, address, bool) {
        require(_bountyId < bounties.length, "Invalid bounty ID");
        Bounty memory b = bounties[_bountyId];
        return (b.description, b.evidenceIPFS, b.submitter, b.approved);
    }
}
