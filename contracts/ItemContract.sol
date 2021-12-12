pragma solidity ^0.8.7;

import "./ItemManager.sol";

contract ItemContract {
    uint public price;
    uint public pricePaid;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _price, uint _index) {
        price = _price;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Item already paid");
        require(price == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        // (bool success,) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index));
        (bool success,) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Transcation wasn't successful, canceling ");
    }
}
