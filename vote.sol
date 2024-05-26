// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }
    //후보자 구조체 정의

    address public owner;
    mapping(address => bool) public voters;
    Candidate[] public candidates;
// 계약 소유자 ==> 배포한 주소를 owner로 설정
//투표한 사람을 확인하기 위해 투표자를 맵핑
//후보자들을 저장하는 배열'candidates'를 사용함
    event Voted(address indexed voter, uint indexed candidateIndex);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted");
        _;
    }
//특정함수에 대한 접근을 제어하기 위해 제한자를 사용

    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }
// 계약을 배포할 때 후보자 이름을 받고 후보자 배열을 초기화함

    function vote(uint candidateIndex) public hasNotVoted {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        voters[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
        emit Voted(msg.sender, candidateIndex);
    }
//vote함수 정의

    function getCandidate(uint index) public view returns (string memory name, uint voteCount) {
        require(index < candidates.length, "Invalid candidate index");
        Candidate storage candidate = candidates[index];
        return (candidate.name, candidate.voteCount);
    }
//후보자의 이름과 득표수를 조회할 수 있는 함수 정의

    function getNumberOfCandidates() public view returns (uint) {
        return candidates.length;
    }
}
//후보자 총 수를 반환할 수 있음
