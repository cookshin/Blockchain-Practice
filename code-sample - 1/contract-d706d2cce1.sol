// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/governance/Governor.sol";//기본 거버넌스기능
import "@openzeppelin/contracts@5.0.2/governance/extensions/GovernorSettings.sol";//투표지연, 투표기간, 제안 임계값 설정
import "@openzeppelin/contracts@5.0.2/governance/extensions/GovernorCountingSimple.sol";//단순 투표 계산
import "@openzeppelin/contracts@5.0.2/governance/extensions/GovernorVotes.sol";//투표 토큰기반 거버넌스
import "@openzeppelin/contracts@5.0.2/governance/extensions/GovernorVotesQuorumFraction.sol";//정족수 설정
import "@openzeppelin/contracts@5.0.2/governance/extensions/GovernorTimelockControl.sol";//타임락 컨트롤 포함

contract MyGovernor is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction, GovernorTimelockControl {
    constructor(IVotes _token, TimelockController _timelock)//상속
        Governor("MyGovernor")//거버넌스 계약 이름
        GovernorSettings(7200 /* 1 day */, 50400 /* 1 week */, 0)// 투표 지연 (7200블록, 1일), 투표 기간 (50400블록, 1주), 제안 임계값 (0)
        GovernorVotes(_token)//투표에 사용될 토큰
        GovernorVotesQuorumFraction(4)// 정족수 설정 (4%)
        GovernorTimelockControl(_timelock)
    {}

    // The following functions are overrides required by Solidity.
// 다중 상속을 지원하므로 여러 계약으로 부터 상속될 수 있으므로 특정 계약에서 오버라이드가 필요. 

    function votingDelay()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();//투표 지연시간 반환
    }

    function votingPeriod()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();//투표기간 반환
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);//특정 블록번호에서 필요 정족수 반환
    }

    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);//제안 상태 반환
    }

    function proposalNeedsQueuing(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);//제안이 큐잉이 필요한지 여부 반환
    }

    function proposalThreshold()
        public
        view
        override(Governor, GovernorSettings)
        returns (uint256)
    {
        return super.proposalThreshold();//제안 임계값 반환
    }

    function _queueOperations(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint48)
    {
        return super._queueOperations(proposalId, targets, values, calldatas, descriptionHash);
    }//제안을 큐잉함

    function _executeOperations(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }//제안을 실행함

    function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }//제안을 취소함

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }//실행자를 반환함
}
