// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {HuffCTFRegistry} from "../src/HuffCTFRegistry.sol";

contract CounterTest is Test {
    HuffCTFRegistry public registry;

    function setUp() public {
        registry = new HuffCTFRegistry();
        registerMockUsers();
    }
    // function register(uint8 ctfId, string calldata solverHandle, bytes32 codeHash, uint256 gas) public {

    function registerMockUsers() public {
        // ctfId 1
        vm.warp(111);
        vm.prank(address(0x111));
        registry.register(1, "user111", keccak256("111's code"), 100);

        vm.warp(222);
        vm.prank(address(0x222));
        registry.register(1, "user222", keccak256("222's code"), 50);

        vm.warp(333);
        vm.prank(address(0x333));
        registry.register(1, "user333", keccak256("333's code"), 200);


        // ctfId 2
        vm.warp(1000);
        vm.prank(address(0x333));
        registry.register(2, "user333", keccak256("333's code"), 2000);

        vm.warp(1016);
        vm.prank(address(0x222));
        registry.register(2, "user222", keccak256("222's code"), 1900);
    }

    function test_getSolver() public {
        address solver = registry.getSolver(1, 1);
        assertEq(solver, address(0x222));

        solver = registry.getSolver(2, 1);
        assertEq(solver, address(0x222));
    }

    function test_getSolvers() public {
        address[] memory solvers = registry.getSolvers(1);
        assertEq(solvers.length, 3);
        assertEq(solvers[0], address(0x111));
        assertEq(solvers[1], address(0x222));
        assertEq(solvers[2], address(0x333));

        solvers = registry.getSolvers(2);
        assertEq(solvers.length, 2);
        assertEq(solvers[0], address(0x333));
        assertEq(solvers[1], address(0x222));
    }

    function test_getSolutions() public {
        HuffCTFRegistry.CtfSolution[] memory solutions = registry.getSolutions(1);
        assertEq(solutions.length, 3);

        assertEq(solutions[0].solverAddress, address(0x111));
        assertEq(solutions[0].ctfId, 1);
        assertEq(solutions[0].timestamp, 111);
        assertEq(solutions[0].gas, 100);
        assertEq(solutions[0].codeHash, keccak256("111's code"));
        assertEq(keccak256(abi.encode(solutions[0].solverHandle)), keccak256(abi.encode("user111")));

        assertEq(solutions[1].solverAddress, address(0x222));
        assertEq(solutions[1].ctfId, 1);
        assertEq(solutions[1].timestamp, 222);
        assertEq(solutions[1].gas, 50);
        assertEq(solutions[1].codeHash, keccak256("222's code"));
        assertEq(keccak256(abi.encode(solutions[1].solverHandle)), keccak256(abi.encode("user222")));

        assertEq(solutions[2].solverAddress, address(0x333));
        assertEq(solutions[2].ctfId, 1);
        assertEq(solutions[2].timestamp, 333);
        assertEq(solutions[2].gas, 200);
        assertEq(solutions[2].codeHash, keccak256("333's code"));
        assertEq(keccak256(abi.encode(solutions[2].solverHandle)), keccak256(abi.encode("user333")));

        solutions = registry.getSolutions(2);
        assertEq(solutions.length, 2);

    }

    function test_getSolversRankedByTimestamp() public {
        HuffCTFRegistry.CtfSolution[] memory solutions = registry.getSolversRankedByTimestamp(1);
        assertEq(solutions.length, 3);
        assertEq(solutions[0].solverAddress, address(0x111));
        assertEq(solutions[1].solverAddress, address(0x222));
        assertEq(solutions[2].solverAddress, address(0x333));

        solutions = registry.getSolversRankedByTimestamp(2);
        assertEq(solutions.length, 2);
        assertEq(solutions[0].solverAddress, address(0x333));
        assertEq(solutions[1].solverAddress, address(0x222));
    }

    function test_getSolversRankedByGas() public {
        HuffCTFRegistry.CtfSolution[] memory solutions = registry.getSolversRankedByGas(1);
        assertEq(solutions.length, 3);

        assertEq(solutions[0].solverAddress, address(0x222));
        assertEq(solutions[1].solverAddress, address(0x111));
        assertEq(solutions[2].solverAddress, address(0x333));

        solutions = registry.getSolversRankedByGas(2);
        assertEq(solutions.length, 2);
        assertEq(solutions[0].solverAddress, address(0x222));
        assertEq(solutions[1].solverAddress, address(0x333));

    }
}
