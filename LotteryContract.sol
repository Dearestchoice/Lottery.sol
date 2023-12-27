//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

   contract Lottery {
    address public manager;
    address[] public players;

    event WinnerSelected(address winner);

    modifier onlyManager() {
       require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

constructo() {
 manager = msg.sender;
    }

function enter() public payable {
        require(msg.value >= 0.01 ether, "Minimum entry fee is 0.01 ether");
        require(msg.sender != manager, "Manager cannot participate");
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, players, blockhash(block.number - 1))));
    }

    function pickWinner() public onlyManager {
        require(players.length > 0, "No players participated in the lottery");

        uint index = random() % players.length;
        address winner = players[index];

        // Transfer the balance to the winner
        uint contractBalance = address(this).balance;
        require(contractBalance > 0, "Contract balance is empty");
        (bool success, ) = payable(winner).call{value: contractBalance}("");
        require(success, "Transfer to winner failed");

        // Reset the players array for the next lottery
        players = new address[](0);

        emit WinnerSelected(winner);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

