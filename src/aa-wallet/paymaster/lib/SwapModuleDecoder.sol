//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

library SwapModuleDecoder {
    function decodeSwapArgs(bytes memory _calldata)
        internal
        pure
        returns (uint256, address[] memory)
    {
        bytes memory data = extractCalldata(_calldata);

        (uint256 tokenInAmount, address[] memory path) = abi.decode(
            data,
            (uint256, address[])
        );

        return (tokenInAmount, path);
    }

    function extractCalldata(bytes memory _calldata)
        internal
        pure
        returns (bytes memory)
    {
        bytes memory data;

        require(_calldata.length >= 4);

        assembly {
            let totalLength := mload(_calldata)
            let targetLength := sub(totalLength, 4)
            data := mload(0x40)

            mstore(data, targetLength)
            mstore(0x40, add(0x20, targetLength))
            mstore(add(data, 0x20), shl(0x20, mload(add(_calldata, 0x20))))

            for {
                let i := 0x1C
            } lt(i, targetLength) {
                i := add(i, 0x20)
            } {
                mstore(
                    add(add(data, 0x20), i),
                    mload(add(add(_calldata, 0x20), add(i, 0x04)))
                )
            }
        }

        return data;
    }

    function getSelector(bytes memory _data) internal pure returns (bytes4) {
        bytes4 selector;
        assembly {
            selector := calldataload(_data)
        }
        return selector;
    }
}
