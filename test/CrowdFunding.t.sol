// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CrowdFunding.sol";

contract CrowdFundingTest is Test {
  CrowdFunding public crowdFunding;
  // bob will be our campaign owner and alice will be our donator
  address bob = address(0x1);
  address alice = address(0x2);

  function setUp() public {
    // this is like the beforeEach() while testing in JS, it will run before each test
    // we will create a new CrowdFunding contract instance and assign it to the crowdFunding variable before each test
    // we will also give alice some ether to donate to the campaign before each test
    crowdFunding = new CrowdFunding();
    vm.deal(alice, 1000);
  }

  function testCreateCampaign() public {
    // call the createCampaign() function with bob's address and store the returned id in a variable
    uint256 id = crowdFunding.createCampaign(
      address(bob),
      "Test Title",
      "Test Description",
      100,
      block.timestamp + 10000,
      "https://i.kym-cdn.com/photos/images/newsfeed/002/205/307/1f7.jpg"
    );
    // log the id, also a feature of foundry
    emit log_uint(id);
    // different way of logging
    emit log_named_uint("id", id);
    // for the first campaign, the id should be 0 [line 29 in src/CrowdFunding.sol]
    assertEq(id, 0);
  }

  function testDonateToCampaign() public {
    uint256 id = crowdFunding.createCampaign(
      address(bob),
      "Test Title",
      "Test Description",
      100,
      block.timestamp + 10000,
      "https://i.kym-cdn.com/photos/images/newsfeed/002/205/307/1f7.jpg"
    );
    // This is a cheat code in foundry, we will use the vm.prank(address) function to make bob the msg.sender for the next call
    vm.prank(alice);
    // from now on, alice will be the msg.sender while calling functions
    // alice will call the donateToCampaign() function with the id of the campaign she wants to donate to
    crowdFunding.donateToCampaign{ value: 100 }(id);

    uint256 contractBalance = address(crowdFunding).balance;
    // after donating, the contract balance should be 100
    assertEq(contractBalance, 100);
  }
}
