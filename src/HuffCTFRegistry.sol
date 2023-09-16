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

    mapping(address => CtfSolution) public solvers;
    mapping(uint8 ctfId => address[] solverAddresses) public solutions; // by ctfId

    // @notice the same account calling this fn with the same ctfId will overwrite the previous solution submitted
    function register(uint8 ctfId, string calldata solverHandle, bytes32 codeHash, uint256 gas) public {
        solvers[msg.sender] = CtfSolution({
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
            ctfSolutions[i] = solvers[solverAddresses[i]];
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
        if (sortType == SortType.Timestamp) {
            quickSortTimestamp(data, int256(0), int256(data.length - 1));

        } else if (sortType == SortType.Gas) {
            quickSortGas(data, int256(0), int256(data.length - 1));
        }
        return data;
    }

    function getSortCriteria(CtfSolution memory data, SortType sortType) public pure returns (uint256) {
        return sortType == SortType.Timestamp ? data.timestamp : data.gas;
    }

    function quickSortTimestamp(CtfSolution[] memory arr, int256 left, int256 right) pure internal {
        int256 i = left;
        int256 j = right;
        if (i == j) return;
        uint256 pivot = arr[uint256(left + (right - left) / 2)].timestamp;
        while (i <= j) {
            while (arr[uint256(i)].timestamp < pivot) i++;
            while (pivot < arr[uint256(j)].timestamp) j--;
            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (arr[uint256(j)], arr[uint256(i)]);
                i++;
                j--;
            }
        }
        if (left < j) {
            quickSortTimestamp(arr, left, j);
        }
        if (i < right) {
            quickSortTimestamp(arr, i, right);
        }
    }

    function quickSortGas(CtfSolution[] memory arr, int256 left, int256 right) pure internal {
        int256 i = left;
        int256 j = right;
        if (i == j) return;
        uint256 pivot = arr[uint256(left + (right - left) / 2)].gas;
        while (i <= j) {
            while (arr[uint256(i)].gas < pivot) i++;
            while (pivot < arr[uint256(j)].gas) j--;
            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (arr[uint256(j)], arr[uint256(i)]);
                i++;
                j--;
            }
        }
        if (left < j) {
            quickSortGas(arr, left, j);
        }
        if (i < right) {
            quickSortGas(arr, i, right);
        }
    }
}
