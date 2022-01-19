pragma solidity ^0.5.0;

import "./Token.sol";


contract EthSwap {
	string public name = "EthSwap Instant Exchange";
	Token public token;
	uint public rate = 100;

	event TokensPurchased(
		address account,
		address token,
		uint amount,
		uint rate
	);

	event TokensSold(
		address account,
		address token,
		uint amount,
		uint rate
	);

	constructor(Token _token) public {
		token = _token;
	}

	function buyTokens() public payable {
		//Amount of Ethereum * Redemption rate
		uint tokenAmount = msg.value * rate;
	

		//require that sender has enough to exchange
		require(token.balanceOf(address(this)) >= tokenAmount);

		//Transfer tokens
		token.transfer(msg.sender, tokenAmount);

		//Emit an event
		emit TokensPurchased(msg.sender, address(token),tokenAmount, rate);
	}

	function sellTokens(uint _amount) public {
		//Transfer tokens from investor to Ethswap and return ether
		//user can't sell more tokens than they own
		require(token.balanceOf(msg.sender)>=_amount);

		//Calculate the amount of ether to redeem
		uint etherAmount = _amount / rate;

		//Requrie ethSwap has enought Ether
		require(address(this).balance >= etherAmount);

		//Perform sale. transferFrom function from ERC-20 code
		token.transferFrom(msg.sender, address(this), _amount);

		//Give user ether
		msg.sender.transfer(etherAmount);

		//Emit an event
		emit TokensSold(msg.sender, address(token), _amount, rate);


	}
}
