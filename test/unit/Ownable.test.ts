import { expect } from "../chai-setup";
import { setupUsers, setupUser } from "../utils";
import {
  ethers,
  deployments,
  getNamedAccounts,
  getUnnamedAccounts,
} from "hardhat";

const setup = async () => {
  await deployments.fixture(["all"]);

  const contracts = {
    test: await ethers.getContract("TestContract"),
  };

  const { deployer } = await getNamedAccounts();

  const users = await setupUsers(await getUnnamedAccounts(), contracts);

  return {
    ...contracts,
    users,
    deployer: await setupUser(deployer, contracts),
  };
};

describe("Ownable Tests", () => {
  describe("Deployment", () => {
    it("Should try to change the user", async () => {
      const { test, users } = await setup();

      await expect(users[0].test.changeUser()).to.be.reverted;
    });

    it("Should change the user", async () => {
      const { test, users, deployer } = await setup();

      const tx = await deployer.test.changeUser(users[0].address);
      await tx.wait();

      expect(await test.user()).to.equal(users[0].address);
    });

    it("Should change the owner", async () => {
      const { test, users, deployer } = await setup();

      const tx = await deployer.test.transferOwnership(users[0].address);
      await tx.wait();

      expect(await test.pendingOwner()).to.equal(users[0].address);

      const tx2 = await users[0].test.claimOwnership();
      await tx2.wait();

      expect(await test.owner()).to.equal(users[0].address);
      expect(await test.pendingOwner()).to.equal(ethers.constants.AddressZero);
    });

    it("Should try to claim ownership with wrong address", async () => {
      const { test, users, deployer } = await setup();

      const tx = await deployer.test.transferOwnership(users[0].address);
      await tx.wait();

      expect(await test.pendingOwner()).to.equal(users[0].address);

      await expect(users[1].test.claimOwnership()).to.be.reverted;
    });

    it("Should test if the events are emitted correctly", async () => {
      const { test, users, deployer } = await setup();

      await expect(deployer.test.transferOwnership(users[0].address))
        .to.emit(test, "TransferOwnershipProposed")
        .withArgs(users[0].address);

      await expect(users[0].test.claimOwnership())
        .to.emit(test, "OwnershipTransfered")
        .withArgs(users[0].address);
    });
  });
});
