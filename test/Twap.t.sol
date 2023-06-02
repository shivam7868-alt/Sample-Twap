// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Twap.sol";

contract PericeTest is Test {
    PriceOracle public oracle;

    event AddObservation(uint256 indexed data);

    function setUp() public {
        oracle = new PriceOracle();
    }

    function testGetPriceData() public {
        testAddObservation();
        uint256[] memory data = oracle.getPriceData();
        assertEq(data[0], 900);
        assertEq(data[1], 200);
    }

    function testAddObservation() public {
        vm.expectEmit(false, false, false, true);
        emit AddObservation(900);
        oracle.addObservations(900);
        emit AddObservation(200);
        oracle.addObservations(200);
    }

    function addData() public {
        oracle.addObservations(100);
        oracle.addObservations(400);
        oracle.addObservations(600);
        oracle.addObservations(700);
        oracle.addObservations(800);
        oracle.addObservations(900);
        oracle.addObservations(400);
        oracle.addObservations(200);
        oracle.addObservations(2700);
        oracle.addObservations(250);
        oracle.addObservations(2507);
        oracle.addObservations(206);
        oracle.addObservations(204);
        oracle.addObservations(233);
        oracle.addObservations(2450);
        oracle.addObservations(350);
        oracle.addObservations(5500);
        oracle.addObservations(2060);
        oracle.addObservations(2009);
        oracle.addObservations(2001);
    }

    function testQuery() public {
        addData();
        uint256 averagePrice;
        averagePrice = oracle.query(3);
        assertEq(averagePrice, 2023);

        averagePrice = oracle.query(1);
        assertEq(averagePrice, 2001);
        averagePrice = oracle.query(16);
        assertEq(averagePrice, 1423);
    }

     function testQuery2() public {
        addDataLessThanObservations();
        uint256 averagePrice;
        averagePrice = oracle.query(3);
        assertEq(averagePrice, 800);

        averagePrice = oracle.query(1);
        assertEq(averagePrice, 900);
        averagePrice = oracle.query(16);
        assertEq(averagePrice, 583);
    }

    function addDataLessThanObservations() public {
        oracle.addObservations(100);
        oracle.addObservations(400);
        oracle.addObservations(600);
        oracle.addObservations(700);
        oracle.addObservations(800);
        oracle.addObservations(900);
    }

    function testQuery_Revert() public {
        vm.expectRevert("DATA_NOT_STORED");
        oracle.query(67);
        vm.expectRevert("INCORRECT_INPUT");
        oracle.query(0);
    }
}