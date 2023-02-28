pragma solidity ^0.8.0;

import "zksync-contracts/Constants.sol";
import "zksync-contracts/libraries/SystemContractsCaller.sol";

// import "zksync-contracts/interfaces/IContractDeployer.sol";

contract AccountFactory {
    bytes32 public accountBytecodeHash;

    constructor(bytes32 _accountBytecodeHash) {
        accountBytecodeHash = _accountBytecodeHash;
    }

    function deployAccount(bytes32 salt, address owner)
        external
        returns (address accountAddress)
    {
        // (bool success, bytes memory returnData) = SystemContractsCaller
        //     .systemCallWithReturndata(
        //         uint32(gasleft()),
        //         address(DEPLOYER_SYSTEM_CONTRACT),
        //         uint128(0),
        //         abi.encodeCall(
        //             DEPLOYER_SYSTEM_CONTRACT.create2Account,
        //             (
        //                 salt,
        //                 accountBytecodeHash,
        //                 abi.encode(owner),
        //                 IContractDeployer.AccountAbstractionVersion.Version1
        //             )
        //         )
        //     );

        // require(success, "Deployment Failed");
        // (accountAddress) = abi.decode(returnData, (address));

        bool success = SystemContractsCaller.systemCall(
            uint32(gasleft()),
            address(DEPLOYER_SYSTEM_CONTRACT),
            uint128(0),
            abi.encodeCall(
                DEPLOYER_SYSTEM_CONTRACT.create2Account,
                (
                    salt,
                    accountBytecodeHash,
                    abi.encode(owner),
                    IContractDeployer.AccountAbstractionVersion.Version1
                )
            )
        );

        //require(success, "Deployment Failed");
    }
}
