// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
import "forge-std/console.sol";

contract PriceOracle {
    uint256 private pointer;
    uint256[] private prices = new uint256[](16);

    event AddObservation(uint256 indexed data);

    function addObservations(uint256 _value) external {
        prices[pointer++ % 16] = _value;
        emit AddObservation(_value);
    }

    function query(uint8 _observations) external view returns (uint256 average) {
        require(_observations > 0, "INCORRECT_INPUT");
        require(_observations <= 16, "DATA_NOT_STORED");
        uint8 givenObservations = _observations;

        if (pointer < _observations) {
            for (uint8 i; i < pointer % 16; ++i) average += prices[i];
            average /= pointer;
        } else {
            for (uint256 i = (pointer % 16) - 1; givenObservations > 0; ) {
                if (i == 0) {
                    average += prices[i];
                    i = prices.length -1;
                    --givenObservations;
                    continue;
                }
                average += prices[i];
                unchecked {
                    --i;
                    --givenObservations;
                }
            }
            average /= _observations;
        }
    }

    function getPriceData() external view returns (uint256[] memory) {
        return prices;
    }
}