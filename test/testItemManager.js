const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("should be able to add an item", async function () {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test1";
        const itemPrice = 100;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, {from: accounts[0]});
        assert.equal(result.logs[0].args.index, 0, "It's not the first item");
        assert.equal(result.logs[0].args.id, itemName, "It's not the same name");

        const item = await itemManagerInstance.items(0);
        assert.equal(item.id, itemName, "It's not the same name");
    })

})