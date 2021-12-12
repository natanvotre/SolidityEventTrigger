pragma solidity ^0.8.7;

import "./Ownable.sol";
import "./ItemContract.sol";

contract ItemManager is Ownable {

    enum SupplyChainState{Created, Paid, Delivered}

    struct Item {
        ItemContract item;
        string id;
        uint price;
        SupplyChainState state;
    }

    mapping(uint => Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint index, string id, uint state, address item);

    function createItem(string memory _id, uint _price) public onlyOwner {
        items[itemIndex].item = new ItemContract(this, _price, itemIndex);
        items[itemIndex].id = _id;
        items[itemIndex].price = _price;
        items[itemIndex].state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, items[itemIndex].id, uint(items[itemIndex].state), address(items[itemIndex].item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(_itemIndex <= itemIndex, "Index out of range");
        require(items[_itemIndex].price == msg.value, "Payment is different");
        require(items[_itemIndex].state == SupplyChainState.Created, "Item is further in the chain");

        items[_itemIndex].state == SupplyChainState.Paid;
        emit SupplyChainStep(_itemIndex, items[_itemIndex].id, uint(items[_itemIndex].state), address(items[_itemIndex].item));
    }

    function triggerDelivery(uint _itemIndex) public payable onlyOwner {
        require(_itemIndex <= itemIndex, "Index out of range");
        require(items[_itemIndex].state == SupplyChainState.Paid, "Item is further in the chain");

        items[_itemIndex].state == SupplyChainState.Delivered;
        emit SupplyChainStep(_itemIndex, items[_itemIndex].id, uint(items[_itemIndex].state), address(items[_itemIndex].item));
    }
}
