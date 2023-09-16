// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract HuffCTFRegistry {
    uint256 public number;

    struct CtfSolution {
        uint8 ctfId;
        uint64 timestamp;
        uint24 gas;
        address solverAddress;
        bytes32 codeHash;
        string solverHandle;
    }

    mapping(address solver => mapping(uint8 ctfId => CtfSolution)) public solvers;
    mapping(uint8 ctfId => address[] solverAddresses) public solutions; // by ctfId

    // @notice the same account calling this fn with the same ctfId will overwrite the previous solution submitted
    function register(uint8 ctfId, string calldata solverHandle, bytes32 codeHash, uint256 gas) public {
        solvers[msg.sender][ctfId] = CtfSolution({
            ctfId: ctfId,
            timestamp: uint64(block.timestamp),
            gas: uint24(gas),
            solverAddress: msg.sender,
            codeHash: codeHash,
            solverHandle: solverHandle
        });
        solutions[ctfId].push(msg.sender);
    }

    function getSolver(uint8 ctfId, uint256 index) public view returns (address) {
        return solutions[ctfId][index];
    }

    function getSolvers(uint8 ctfId) public view returns (address[] memory) {
        return solutions[ctfId];
    }

    function getSolutions(uint8 ctfId) public view returns (CtfSolution[] memory ctfSolutions) {
        address[] memory solverAddresses = solutions[ctfId];
        ctfSolutions = new CtfSolution[](solverAddresses.length);
        for (uint256 i = 0; i < solverAddresses.length; i++) {
            ctfSolutions[i] = solvers[solverAddresses[i]][ctfId];
        }
        return ctfSolutions;
    }

    enum SortType {Timestamp, Gas}

    function getSolversRankedByTimestamp(uint8 ctfId) public view returns (CtfSolution[] memory sortedSolutions) {
        return sort(getSolutions(ctfId), SortType.Timestamp);
    }

    function getSolversRankedByGas(uint8 ctfId) public view returns (CtfSolution[] memory sortedSolutions) {
        return sort(getSolutions(ctfId), SortType.Gas);
    }

    // https://ethereum.stackexchange.com/questions/1517/sorting-an-array-of-integer-with-ethereum
    function sort(CtfSolution[] memory data, SortType sortType) public pure returns (CtfSolution[] memory) {
        quickSort(sortType, data, int256(0), int256(data.length - 1));
        return data;
    }

    function getSortCriteria(CtfSolution memory data, SortType sortType) public pure returns (uint256) {
        return sortType == SortType.Timestamp ? data.timestamp : data.gas;
    }

    function quickSort(SortType sortType, CtfSolution[] memory arr, int256 left, int256 right) pure internal {
        int256 i = left;
        int256 j = right;
        if (i == j) return;
        uint256 pivot = getSortCriteria(arr[uint256(left + (right - left) / 2)], sortType);
        while (i <= j) {
            while (getSortCriteria(arr[uint256(i)], sortType) < pivot) i++;
            while (pivot < getSortCriteria(arr[uint256(j)], sortType)) j--;
            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (arr[uint256(j)], arr[uint256(i)]);
                i++;
                j--;
            }
        }
        if (left < j) {
            quickSort(sortType, arr, left, j);
        }
        if (i < right) {
            quickSort(sortType, arr, i, right);
        }
    }
}
