# CTF-Registry

This registry has been deployed on Optimism mainnet at: [0xf6aE79c0674df852104D214E16AC9c065DAE5896](https://optimistic.etherscan.io/address/0xf6aE79c0674df852104D214E16AC9c065DAE5896)

This registry was created for letting CTF players register their solutions.

## Usage

### Register

```
function register(uint8 ctfId, string calldata solverHandle, bytes32 codeHash, uint256 gas) public;
```

To register their solution, players will call this function with the following args:

| Parameter Name | Description                 | Example         |
| -------------- | --------------------------- | --------------- |
| ctfId          | The ID of the CTF           | `0x69`          |
| solverHandle   | The handle for the solver   | `"devtooligan"` |
| codeHash       | The hash of the code        | `0xb0ffedc0de`  |
| gas            | The amount of gas specified | `420`           |


Note: Calling `register()` more than once for a given `ctfId` will overwrite the previous solution submitted.

### View functions


In addition to registering, there are some helpful view functions for managing solutions.

```
    // Retrieves array of addresses of solvers for a given `ctfId`
    function getSolvers(uint8 ctfId) public view returns (address[] memory)
```

----

```
    //Retrieves address of solver at index for a given `ctfId`.
    function getSolver(uint8 ctfId, uint256 index) public view returns (address)
```

----


```
    //Retrieves array of CtfSolution structs for a given `ctfId`.
    function getSolutions(uint8 ctfId) public view returns (CtfSolution[] memory ctfSolutions)

    struct CtfSolution {
        uint8 ctfId;
        uint64 timestamp;
        uint24 gas;
        address solverAddress;
        bytes32 codeHash;
        string solverHandle;
    }
```

----

```
    //Retrieves array of CtfSolution structs for a given `ctfId` sorted by time submitted (`timestamp`) ascending.
    function getSolversRankedByTimestamp(uint8 ctfId) public view returns (CtfSolution[] memory sortedSolutions)
```

----

```
    //Retrieves array of CtfSolution structs for a given `ctfId` sorted by `gas` ascending.
    function getSolversRankedByGas(uint8 ctfId) public view returns (CtfSolution[] memory sortedSolutions)
```

----
