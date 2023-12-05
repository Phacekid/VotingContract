// SPDX-License-Identifier: MIT
// author: Phace
pragma solidity ^0.8.20;

contract Voting {

    address public controller; // deployer is controller

    constructor() {
        controller = msg.sender;
    }

    struct Candidate {
        string name;
        bool isRegistered;
        uint voteCount;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
    }

    mapping(address => Candidate) public candidates;
    mapping(address => Voter) public voters;

    event CandidateAdded(address indexed candidateAddress, string name);
    event VoterRegistered(address indexed voterAddress);
    event VoteCasted(address indexed voterAddress, address indexed candidateAddress);

    modifier onlyController() {
        // only one person has control which is the deployer
        require(msg.sender == controller, "Only controller can perform this action");
        _;
    }

    // a candidate can only be added once
    modifier candidateNotRegistered(address _candidateAddress) {
        require(!candidates[_candidateAddress].isRegistered, "Candidate already registered");
        _;
    }

    // a voter can only be added once or registered once
    modifier voterNotRegistered(address _voterAddress) {
        require(!voters[_voterAddress].isRegistered, "Voter already registered");
    _;
    }

    // voting eligibility check
    modifier voteCheck(address _candidateAddress) {
        require(voters[msg.sender].isRegistered, "Voter not registered");
        require(!voters[msg.sender].hasVoted, "Voter already voted");
        require(candidates[_candidateAddress].isRegistered, "Candidate not registered");
        _;
    }

    // only the controller can add electoral candidate
    function addCandidate(address _candidateAddress, string memory _name) external onlyController candidateNotRegistered(_candidateAddress) {
        candidates[_candidateAddress] = Candidate(_name, true, 0);
        emit CandidateAdded(_candidateAddress, _name);
    }
    
    // only the controller can add potential voter
    function addVoter(address _voterAddress) external onlyController voterNotRegistered(_voterAddress) {
        voters[_voterAddress] = Voter(true, false);
        emit VoterRegistered(_voterAddress);
    }

    // a voter can only vote once
    function vote(address _candidateAddress) external voteCheck(_candidateAddress){
        voters[msg.sender].hasVoted = true;
        candidates[_candidateAddress].voteCount++;
        emit VoteCasted(msg.sender, _candidateAddress);
    }

    // view candidate number of votes
    function viewVotes(address _candidateAddress) public view returns (uint) {
        require(candidates[_candidateAddress].isRegistered == true, "Candidate not registered");
        uint votes = votersCount(_candidateAddress);
        return votes;
    }

    function votersCount(address _candidateAddress) internal view returns (uint) {
        return candidates[_candidateAddress].voteCount;
    }
}
