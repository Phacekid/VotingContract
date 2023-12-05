const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Voting", function () {

  let votingContract;
  let owner, addr1, addr2;

  beforeEach(async function () {

    // Get contract and deploy
    const Voting = await ethers.getContractFactory("Voting");
    votingContract = await Voting.deploy();

    // Get test wallet addresses    
    [owner, addr1, addr2] = await ethers.getSigners();

  });

  it("Should add candidate and emit event", async function () {

    await expect(votingContract.connect(owner).addCandidate(addr1.address, "Candidate 1"))
      .to.emit(votingContract, "CandidateAdded")
      .withArgs(addr1.address, "Candidate 1");

    await expect(votingContract.connect(owner).addCandidate(addr2.address, "Candidate 2"))
      .to.emit(votingContract, "CandidateAdded")
      .withArgs(addr2.address, "Candidate 2");

  });

  it("Should register voter and emit event", async function () {

    await expect(votingContract.connect(owner).addVoter(addr1.address))
      .to.emit(votingContract, "VoterRegistered")
      .withArgs(addr1.address);

    await expect(votingContract.connect(owner).addVoter(addr2.address))
      .to.emit(votingContract, "VoterRegistered")
      .withArgs(addr2.address);

  });

  it("Should record vote and emit event", async function () {

    await votingContract.connect(owner).addVoter(addr1.address);
    await votingContract.connect(owner).addCandidate(addr2.address, "Candidate 2");
    await expect(votingContract.connect(addr1).vote(addr2.address))
      .to.emit(votingContract, "VoteCasted")
      .withArgs(addr1.address, addr2.address);

    await votingContract.connect(owner).addVoter(addr2.address);
    await votingContract.connect(owner).addCandidate(addr1.address, "Candidate 1");
    await expect(votingContract.connect(addr2).vote(addr1.address))
      .to.emit(votingContract, "VoteCasted")
      .withArgs(addr2.address, addr1.address);


  });

});