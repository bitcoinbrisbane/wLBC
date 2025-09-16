// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title wLBC
 * @dev Wrapped LBRY Credits (wLBC) ERC20 token
 * A wrapped version of LBRY Credits that allows for burning and minting capabilities
 */
contract wLBC is ERC20, ERC20Burnable, Ownable {
    uint8 private _decimals;

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     * @param initialSupply The initial supply of tokens
     * @param tokenDecimals The number of decimals for the token
     */
    constructor(
        uint256 initialSupply,
        uint8 tokenDecimals
    ) ERC20("Wrapped LBRY Credits", "wLBC") Ownable(msg.sender) {
        _decimals = tokenDecimals;
        _mint(msg.sender, initialSupply * 10**tokenDecimals);
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Mints tokens to a specified address.
     * Can only be called by the owner.
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Batch mint tokens to multiple addresses.
     * Can only be called by the owner.
     * @param recipients Array of addresses to mint tokens to
     * @param amounts Array of amounts to mint to each recipient
     */
    function batchMint(address[] calldata recipients, uint256[] calldata amounts) 
        public 
        onlyOwner 
    {
        require(recipients.length == amounts.length, "wLBC: arrays length mismatch");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], amounts[i]);
        }
    }
}
