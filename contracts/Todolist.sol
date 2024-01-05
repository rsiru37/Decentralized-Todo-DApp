pragma solidity ^0.8.19;

contract Todolist{
    uint public count;
    address public admin;
    struct Task{
        uint id;
        string content;
        bool check;
    }
    mapping(address => mapping(uint => Task)) public tasks;
    mapping(address=>uint) public tracker;
    function create_task(string memory content) public{
        count++;
        tracker[msg.sender]=tracker[msg.sender]+1;
        tasks[msg.sender][tracker[msg.sender]] = Task(tracker[msg.sender],content,false);
    }
    function check(uint id) public {
        tasks[msg.sender][id].check=true;
    }
    function actual_count() public view returns(uint){
        return tracker[msg.sender];
    }
}
// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.9;

// // Uncomment this line to use console.log
// // import "hardhat/console.sol";

// contract Lock {
//     uint public unlockTime;
//     address payable public owner;

//     event Withdrawal(uint amount, uint when);

//     constructor(uint _unlockTime) payable {
//         require(
//             block.timestamp < _unlockTime,
//             "Unlock time should be in the future"
//         );

//         unlockTime = _unlockTime;
//         owner = payable(msg.sender);
//     }

//     function withdraw() public {
//         // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
//         // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

//         require(block.timestamp >= unlockTime, "You can't withdraw yet");
//         require(msg.sender == owner, "You aren't the owner");

//         emit Withdrawal(address(this).balance, block.timestamp);

//         owner.transfer(address(this).balance);
//     }
// }