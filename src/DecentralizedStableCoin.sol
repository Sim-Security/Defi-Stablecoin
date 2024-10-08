// SPDX-License-Identifier: MIT

// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity 0.8.19;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
    * @title Decentralized Stable Coin
    * @author Adam Simonar - with the help of Cyfrin and Patrick Collins
    * @collateral: Exogenous (wEth and wBTC)
    * @minting: Algorithmic
    * @relative stability: Pegged to USD
    * 
    * This is the contract meant to be governed by DSCEngine. This is just the ERC20 implementation of our stablecoin system
    */
contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin__MustBeMoreThanZero(string message);
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin__NotZeroAddress();

    // address private OWNABLE_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    /**
     * @dev Constructor function for the DecentralizedStableCoin contract.
     * It initializes the ERC20 token with the name "DecentralizedStableCoin" and the symbol "DSC".
     * It also sets the initial owner of the contract.
     */
    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable() {}

    /**
     * @dev Function to burn tokens from the caller's account.
     * It checks if the caller has enough balance to burn the specified amount of tokens.
     * It also checks if the amount to burn is greater than zero.
     * @param _amount The amount of tokens to burn.
     */
    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero("Amount must be more than zero to burn");
        }
        if (_amount > balance) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }
        super.burn(_amount);
    }

    /**
     * @dev Function to mint new tokens and assign them to the specified account.
     * It checks if the specified account is not the zero address.
     * It also checks if the amount to mint is greater than zero.
     * @param _to The account to which the minted tokens will be assigned.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero("Amount must be more than zero to mint");
        }
        _mint(_to, _amount);
        return true;
    }
}
